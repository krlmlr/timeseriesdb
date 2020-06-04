GRANT EXECUTE ON FUNCTION timeseries.insert_collect_from_tmp TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.collection_remove TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.collection_delete TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.dataset_exists TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.keys_in_dataset TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.get_set_of_keys TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.read_metadata_raw TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.read_metadata_localized_raw TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.get_latest_vintages_metadata TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.get_latest_vintages_metadata_localized TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.create_read_tmp_regex TO timeseries_reader;

GRANT EXECUTE ON FUNCTION timeseries.create_dataset TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.assign_dataset TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.md_unlocal_upsert TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.md_local_upsert TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.build_meta_status TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.insert_from_tmp TO timeseries_writer;
