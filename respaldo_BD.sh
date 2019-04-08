#!/bin/sh

pg_dump -v -h localhost -d contingencia -f  /$PATH/BasesDatos/contingencia.sql
pg_dump -v -h localhost -d datafest     -f  /$PATH/BasesDatos/datafest.sql
pg_dump -v -h localhost -d db_sms       -f  /$PATH/BasesDatos/db_sms.sql
pg_dump -v -h localhost -d maincca      -f  /$PATH/BasesDatos/maincca.sql
pg_dump -v -h localhost -d pumabus      -f  /$PATH/BasesDatos/pumabus.sql
pg_dump -v -h localhost -d viajandodf   -f  /$PATH/BasesDatos/viajandodf.sql
