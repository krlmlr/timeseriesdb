docker stop timeseriesdb_dev
docker run --rm -d -p 1111:5432 --name timeseriesdb_dev  postgres:11
sleep 2
psql -p 1111 -h 'localhost' -d postgres -U postgres -f sql/create_roles.sql
psql -p 1111 -h 'localhost' -d postgres -U postgres -f sql/create_extensions.sql
psql -p 1111 -h 'localhost' -d postgres -U postgres -f sql/create_tables.sql
psql -p 1111 -h 'localhost' -d postgres -U postgres -f sql/create_functions_collections.sql
psql -p 1111 -h 'localhost' -d postgres -U postgres -f sql/create_functions_datasets.sql
psql -p 1111 -h 'localhost' -d postgres -U postgres -f sql/create_functions_metadata.sql
psql -p 1111 -h 'localhost' -d postgres -U postgres -f sql/create_functions_ts.sql
psql -p 1111 -h 'localhost' -d postgres -U postgres -f sql/create_triggers.sql
