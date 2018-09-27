psql --dbname=postgres --file=./db/create_db.sql 
psql --dbname=finance_manager --file=./db/create_tables.sql
psql --dbname=finance_manager --file=./db/create_views.sql
psql --dbname=finance_manager --file=./db/initial_load.sql
