CREATE FUNCTION timeseries.dataset_exists(dataset_name TEXT)
RETURNS BOOL
AS $$
BEGIN
  RETURN EXISTS(SELECT 1 FROM timeseries.datasets WHERE set_id = dataset_name);
END;
$$ LANGUAGE PLPGSQL;



CREATE FUNCTION timeseries.collection_add(collection_name TEXT,
                                          owner TEXT,
                                          description TEXT)
RETURNS uuid
AS $$
  INSERT INTO timeseries.collections(name, owner, description) 
  VALUES(collection_name, owner, description) 
  ON CONFLICT DO NOTHING
  RETURNING id
$$ LANGUAGE SQL;



CREATE FUNCTION timeseries.collection_remove()
RETURNS JSON
AS $$
DECLARE 
  result JSON;
BEGIN
  CREATE TEMP TABLE removed_keys (ts_key TEXT PRIMARY KEY) ON COMMIT DROP;
  CREATE TEMP TABLE removed_collect (id TEXT PRIMARY KEY) ON COMMIT DROP;
  
  WITH del_q AS (
    DELETE FROM timeseries.collect_catalog cc
    USING tmp_collection_remove rm
    WHERE cc.ts_key = rm.ts_key
    RETURNING rm.ts_key
  )
  INSERT INTO removed_keys
  SELECT ts_key FROM del_q;
  
  WITH del_collect AS (
  -- 'der letzte macht das licht aus'
  -- keeping an entirely empty set makes no sense, 
  -- hence we delete a set that does not contain 
  -- any series after removing keys.
    DELETE FROM timeseries.collections c
    USING tmp_collection_remove r
    WHERE c.id = r.c_id
    AND NOT EXISTS(SELECT 1 FROM timeseries.collect_catalog
    WHERE id IN (SELECT DISTINCT(r.c_id) FROM tmp_collection_remove r))
    RETURNING c.id
  )
  INSERT INTO removed_collect
  SELECT DISTINCT(id) FROM del_collect;
  
  
  SELECT json_build_object('number_of_removed_keys', count(k.ts_key),
                           'removed_keys', json_agg(k.ts_key),
                           'removed_collections', json_agg(DISTINCT(c.id)))
  INTO result
  FROM removed_keys k
  -- this is needed cause a comma separated FROM is basically 
  -- an inner join which does not work with no key to join on. 
  LEFT JOIN removed_collect c ON(TRUE); 

  RETURN result;
END;
$$ LANGUAGE PLPGSQL;









CREATE FUNCTION timeseries.create_dataset(dataset_name TEXT,
                                          dataset_description TEXT DEFAULT NULL,
                                          dataset_md JSON DEFAULT NULL)
RETURNS TEXT
AS $$
  INSERT INTO timeseries.datasets(set_id, set_description, set_md)
  VALUES(dataset_name, dataset_description, dataset_md)
  RETURNING set_id
$$ LANGUAGE SQL;


CREATE FUNCTION timeseries.insert_collect_from_tmp()
RETURNS JSON
AS $$
DECLARE
  v_invalid_keys JSON;
BEGIN
  CREATE TEMPORARY TABLE tmp_invalid_keys (ts_key TEXT PRIMARY KEY) ON COMMIT DROP;
  INSERT INTO tmp_invalid_keys (
    SELECT DISTINCT tmp_collect_updates.ts_key
    FROM tmp_collect_updates
    LEFT OUTER JOIN timeseries.catalog
    ON timeseries.catalog.ts_key = tmp_collect_updates.ts_key 
    WHERE timeseries.catalog.ts_key IS NULL
  );
  
  INSERT INTO timeseries.collect_catalog (id, ts_key) 
  SELECT c_id, ts_key FROM tmp_collect_updates
  WHERE ts_key NOT IN (SELECT * FROM tmp_invalid_keys)
  ON CONFLICT DO NOTHING;
  
  SELECT json_agg(DISTINCT tmp_invalid_keys.ts_key)
  INTO v_invalid_keys
  FROM tmp_invalid_keys;
  
  IF json_array_length(v_invalid_keys) > 0 THEN
    RETURN json_build_object('status', 'ok',
                             'message', 'Some series could not be added to the user specific collection because these series were not found in the database.',
                             'invalid_keys', v_invalid_keys);
  END IF;
  
  -- All went well
  RETURN '{"status": "ok", "message": "All keys have been successfully added to the collection."}'::JSON;
END;
$$ LANGUAGE PLPGSQL;


CREATE FUNCTION timeseries.insert_from_tmp()
RETURNS JSON
AS $$
DECLARE
  v_invalid_keys TEXT[];
BEGIN
  SELECT array_agg(DISTINCT tmp.ts_key)
  INTO v_invalid_keys
  FROM tmp_ts_updates AS tmp
  INNER JOIN timeseries.timeseries_main AS main
  ON tmp.ts_key = main.ts_key
  AND tmp.validity < main.validity;
  
  -- IMPORTANT!!!
  -- When converting this to a warning, make sure to delete
  -- invalid keys from update table, elsewise updating the past is possible!
  IF array_length(v_invalid_keys, 1) > 0 THEN
    RETURN json_build_object('status', 'failure',
                             'reason', 'keys with invalid vintages',
                             'offending_keys', to_json(v_invalid_keys));
  END IF;
  
  -- after this insert the set_id is 'default' because we don't want a set parameter in our
  -- store functions
  INSERT INTO timeseries.catalog
  SELECT tmp_ts_updates.ts_key
  FROM tmp_ts_updates
  LEFT OUTER JOIN timeseries.catalog ON (timeseries.catalog.ts_key = tmp_ts_updates.ts_key)
  WHERE timeseries.catalog.ts_key IS NULL;

  -- Generate computed property "coverage"  
  ALTER TABLE tmp_ts_updates
  ADD COLUMN coverage DATERANGE;
  UPDATE tmp_ts_updates
  SET coverage = concat('[', ts_data->'time'->0, ',', ts_data->'time'->-1, ')')::daterange;

  -- Main insert  
  INSERT INTO timeseries.timeseries_main(ts_key, validity, coverage, release_date, ts_data, access)
  SELECT tmp.ts_key, COALESCE(tmp.validity, CURRENT_DATE), tmp.coverage, COALESCE(tmp.release_date, CURRENT_TIMESTAMP), tmp.ts_data, tmp.access
  FROM tmp_ts_updates AS tmp
  LEFT JOIN timeseries.timeseries_main AS main
  ON tmp.ts_key = main.ts_key
  AND tmp.validity = main.validity
  ON CONFLICT (ts_key, validity) DO UPDATE
  SET
    coverage = EXCLUDED.coverage,
    release_date = EXCLUDED.release_date,
    created_by = EXCLUDED.created_by,
    created_at = EXCLUDED.created_at,
    ts_data = EXCLUDED.ts_data;
  
  -- All went well
  RETURN '{"status": "ok", "reason": "the world is full of rainbows"}'::JSON;
END;
$$ LANGUAGE PLPGSQL
-- Read this tho: https://www.cybertec-postgresql.com/en/abusing-security-definer-functions/
SECURITY DEFINER;

CREATE FUNCTION timeseries.create_read_tmp_regex(pattern TEXT)
RETURNS VOID
AS $$
  DROP TABLE IF EXISTS tmp_ts_read_keys;
  CREATE TEMPORARY TABLE tmp_ts_read_keys AS(
  SELECT ts_key FROM timeseries.catalog
  WHERE ts_key ~ 'ts');
$$ LANGUAGE SQL;

CREATE FUNCTION timeseries.read_ts_raw(valid_on DATE DEFAULT CURRENT_DATE, respect_release_date BOOLEAN DEFAULT false)
RETURNS TABLE(ts_key TEXT, ts_data JSON)
AS $$
BEGIN
  RETURN QUERY SELECT distinct on (rd.ts_key) rd.ts_key, mn.ts_data
    FROM tmp_ts_read_keys as rd
    JOIN timeseries.timeseries_main as mn
    ON rd.ts_key = mn.ts_key
    AND ((NOT respect_release_date) OR mn.release_date <= CURRENT_TIMESTAMP)
    AND mn.validity <= valid_on
    ORDER BY rd.ts_key, mn.validity DESC;
END;
$$ LANGUAGE PLPGSQL; -- plpgsql because plain sql would (somewhat rightly) complain that the tmp table does not exist

CREATE FUNCTION timeseries.keys_in_dataset(id TEXT)
RETURNS TABLE(ts_key TEXT)
AS $$
BEGIN
  RETURN QUERY SELECT timeseries.catalog.ts_key
  FROM timeseries.catalog
  WHERE id = set_id;
END;
$$ LANGUAGE PLPGSQL;

CREATE FUNCTION timeseries.get_set_of_keys()
RETURNS TABLE(ts_key TEXT, set_id TEXT)
AS $$
BEGIN
  RETURN QUERY SELECT tmp.ts_key, cat.set_id
  FROM tmp_get_set AS tmp
  LEFT JOIN timeseries.catalog AS cat
  ON cat.ts_key = tmp.ts_key;
END;
$$ LANGUAGE PLPGSQL;

CREATE FUNCTION timeseries.assign_dataset(id TEXT)
RETURNS JSON
AS $$
DECLARE
  v_keys_not_in_catalog TEXT[];
BEGIN
  IF NOT EXISTS(SELECT 1 FROM timeseries.datasets WHERE set_id = id) THEN
    RETURN ('{"status": "failure", "reason": "Dataset ' || id || ' does not exist!"}')::JSON;
  END IF; -- Welcome to the stone age of programming
  
  UPDATE timeseries.catalog AS cat
  SET set_id = id
  FROM tmp_set_assign AS tmp -- "FROM" ;P
  WHERE cat.ts_key = tmp.ts_key;
  
  SELECT array_agg(tmp.ts_key)
  FROM tmp_set_assign AS tmp
  LEFT JOIN
    timeseries.catalog AS cat
  ON tmp.ts_key = cat.ts_key
  WHERE cat.ts_key IS NULL
  INTO v_keys_not_in_catalog;
  
  IF array_length(v_keys_not_in_catalog, 1) != 0 THEN
    RETURN ('{"status": "warning",'
    '"reason": "Some keys are not in catalog!",'
    '"offending_keys": ["' || array_to_string(v_keys_not_in_catalog, '", "') || '"]}')::JSON;
  ELSE
    RETURN '{"status": "ok"}'::JSON;
  END IF;
END;
$$ LANGUAGE PLPGSQL;
