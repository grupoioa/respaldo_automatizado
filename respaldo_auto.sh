#!/bin/sh

# Rutas
PATH_TXT='/home/my_user/scripts_backup_owgis'
PATH_REMOTE_DB='/home/raul/respaldos/BasesDatos'
PATH_NCMWS='/usr/local/owgisconfig/ncwms'
PATH_BACKUP='/DATA/RESPALDO_OWGIS_I'

rsync -avtbr -e 'ssh' --rsync-path='sudo rsync' --files-from='/$PATH_TXT/archivos_a_respaldar.txt' --exclude-from='/$PATH_TXT/archivos_a_omitir.txt' --delete-excluded --filter='protect my_folder_backup*' OWGIS_server:/  /$PATH_BACKUP/my_folder_backup

rsync -avtbr --delete-excluded --filter='protect my_folder_backup*' OWGIS_server:/$PATH_REMOTE_DB /$PATH_BACKUP/my_folder_backup

rsync -avtbr --delete-excluded --min-size=100k --filter='protect respaldo_*' OWGIS_server:/$PATH_REMOTE/owgisconfig/ncwms/config.xml  /$PATH_BACKUP/my_folder_backup/my_folder_owgis_config

rsync -avtbr --delete-excluded --filter='protect my_folder_backup*' OWGIS_server:/usr/local/owgisconfig/ncwms/palettes /$PATH_BACKUP/my_folder_backup/my_folder_owgis_config
