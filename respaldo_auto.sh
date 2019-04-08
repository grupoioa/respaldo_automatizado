#!/bin/sh

rsync -avtbr -e 'ssh' --rsync-path='sudo rsync' --files-from='/$PATH/archivos_a_respaldar.txt' --exclude-from='/$PATH/archivos_a_omitir.txt' --delete-excluded --filter='protect <carpeta_respaldo>*' <alias_servidor>:/  /$PATH_HOME/<carpeta_respaldo>

rsync -avtbr --delete-excluded --filter='protect <carpeta_respaldo>*' <alias_servidor>:/$PATH/respaldos/BasesDatos /$PATH_HOME/<carpeta_respaldo>

rsync -avtbr --delete-excluded --min-size=100k --filter='protect respaldo_*' <alias_servidor>:/$PATH/owgisconfig/ncwms/config.xml  /$PATH_HOME/<carpeta_respaldo>/<carpeta_owgis_config>

rsync -avtbr --delete-excluded --filter='protect respaldo_*' <alias_servidor>:/$PATH/owgisconfig/ncwms/palettes /$PATH_HOME/<carpeta_respaldo>/<carpeta_owgis_config>
