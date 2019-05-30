#!/bin/sh

pg_dump -v -h localhost -d contingencia -f  /$PATH_REMOTE_DB/contingencia.sql
pg_dump -v -h localhost -d datafest     -f  /$PATH_REMOTE_DB/datafest.sql
pg_dump -v -h localhost -d db_sms       -f  /$PATH_REMOTE_DB/db_sms.sql
pg_dump -v -h localhost -d maincca      -f  /$PATH_REMOTE_DB/maincca.sql
pg_dump -v -h localhost -d pumabus      -f  /$PATH_REMOTE_DB/pumabus.sql
pg_dump -v -h localhost -d viajandodf   -f  /$PATH_REMOTE_DB/viajandodf.sql
