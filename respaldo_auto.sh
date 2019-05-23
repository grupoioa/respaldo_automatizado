#!/bin/sh

rsync -avtbr -e 'ssh' --rsync-path='sudo rsync' --files-from='/$PATH_SCRIPTS/archivos_a_respaldar.txt' --exclude-from='/$PATH_SCRIPTS/archivos_a_omitir.txt' --delete-excluded --filter='protect <carpeta_respaldo>*' <alias_servidor>:/  /$PATH_BACKUP/<carpeta_respaldo>

rsync -avtbr --delete-excluded --filter='protect <carpeta_respaldo>*' <alias_servidor>:/$PATH_REMOTE/respaldos/BasesDatos /$PATH_BACKUP/<carpeta_respaldo>

rsync -avtbr --delete-excluded --min-size=100k --filter='protect respaldo_*' <alias_servidor>:/$PATH_REMOTE/owgisconfig/ncwms/config.xml  /$PATH_BACKUP/<carpeta_respaldo>/<carpeta_owgis_config>

rsync -avtbr --delete-excluded --filter='protect respaldo_*' <alias_servidor>:/$PATH_REMOTE/owgisconfig/ncwms/palettes /$PATH_BACKUP/<carpeta_respaldo>/<carpeta_owgis_config>
