REVOKE EXECUTE ON FUNCTION timeseries.collection_insert FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_rename FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.collection_remove_keys FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.collection_delete FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.collection_get_keys FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.collection_list FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.dataset_exists FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.dataset_get_keys FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.keys_get_dataset FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_read_raw(DATE) FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_read_raw(TEXT[], DATE) FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_localized_read_raw(DATE, TEXT) FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_localized_read_raw(TEXT[], DATE, TEXT) FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_collection_read_raw FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_collection_localized_read_raw FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_dataset_read_raw FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_dataset_localized_read_raw FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_read_raw(TEXT[], DATE, BOOLEAN) FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_read_raw(DATE, BOOLEAN) FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_read_long FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_read_dataset_raw(TEXT[], DATE, BOOLEAN) FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_read_dataset_raw(DATE, BOOLEAN) FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_read_collection_raw FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_get_latest_vintages FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_localized_get_latest_vintages FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.helper_keys_fill_read_regex FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.dataset_create FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.dataset_add_keys FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_unlocalized_upsert FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.metadata_localized_upsert FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.build_meta_status FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_insert FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.dataset_list FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_change_access_level FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.dataset_change_access_level FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.dataset_delete FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_delete FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_delete_edge FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_trim_history FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.dataset_trim_history FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.prevent_delete_default_dataset FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.release_create FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.release_update FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.release_cancel FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.release_list FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.release_get FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.release_get_latest FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.release_get_next FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.access_level_list FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.access_level_insert FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.access_level_set_default FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.access_level_delete FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_get_access_level FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.dataset_update FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_read_history_raw FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_get_last_update() FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_get_last_update(TEXT[]) FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.collection_get_last_update FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.dataset_get_last_update FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.ts_find_keys FROM public;
REVOKE EXECUTE ON FUNCTION timeseries.get_version FROM public;

GRANT EXECUTE ON FUNCTION timeseries.collection_insert TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.collection_remove_keys TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.collection_delete TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.collection_get_keys TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.collection_list TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.dataset_exists TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.dataset_get_keys TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.keys_get_dataset TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.metadata_read_raw(DATE) TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.metadata_read_raw(TEXT[], DATE) TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.metadata_localized_read_raw(DATE, TEXT) TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.metadata_localized_read_raw(TEXT[], DATE, TEXT) TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.metadata_collection_read_raw TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.metadata_collection_localized_read_raw TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.metadata_dataset_read_raw TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.metadata_dataset_localized_read_raw TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_read_raw(TEXT[], DATE, BOOLEAN) TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_read_raw(DATE, BOOLEAN) TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_read_long TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_read_dataset_raw(TEXT[], DATE, BOOLEAN) TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_read_dataset_raw(DATE, BOOLEAN) TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_read_collection_raw TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.metadata_get_latest_vintages TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.metadata_localized_get_latest_vintages TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.helper_keys_fill_read_regex TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.dataset_list TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.release_list TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.release_get TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.release_get_latest TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.release_get_next TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.access_level_list TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_get_access_level TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_read_history_raw TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_get_last_update() TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_get_last_update(TEXT[]) TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.collection_get_last_update TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.dataset_get_last_update TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.ts_find_keys TO timeseries_reader;
GRANT EXECUTE ON FUNCTION timeseries.get_version TO timeseries_reader;

GRANT EXECUTE ON FUNCTION timeseries.dataset_add_keys TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.metadata_unlocalized_upsert TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.metadata_localized_upsert TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.build_meta_status TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.ts_insert TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.ts_change_access_level TO timeseries_writer;
GRANT EXECUTE ON FUNCTION timeseries.dataset_change_access_level TO timeseries_writer;
