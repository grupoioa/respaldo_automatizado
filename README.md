# Respaldo Automatizado

El objetivo de este script es automatizar el respaldo de archivos especificos que se encuentran en un servidor  
remoto OWGIS desde nuestro equipo local.

## Primeros pasos
Para obtener una copia del proyecto basta con hacer lo siguiente : 
   
   `git clone https://github.com/grupoioa/respaldo_automatizado.git`  

Y se tienen que sustituir las variables *PATH_TXT* y *PATH_BACKUP* tanto del archivo `respaldo_auto.sh` como del archivo  
`respaldo_BD.sh` donde :  

   * PATH_TXT : es la ruta en donde se encuentran nuestros archivos *respaldo_auto.sh*, *archivos_a_respaldar.txt* y  
     *archivos_a_omitir.txt*.  
   * PATH_BACKUP: es la ruta de nuestro equipo o servidor en donde se guardara el respaldo de nuestra información.  
   
### Requerimientos Técnicos
   * Sistemas operativo Ubuntu
   * Lenguaje __Bash__
   * Herramienta __Rsync__  

### Configuración del ambiente
Se debe tener una serie de configuraciones previas que nos permitiran hacer los respaldos de los archivos de manera  
automatizada sin que tengamos que supervisar personalmente cada vez que se ejecuta el script.

__Creamos un alias del servidor remoto__

   1. Ingresamos al archivo `.ssh/config` para crear el alias de nuestro servidor  
      ```bash
      Host OWGIS_server
      HostName 132.248.8.238  
      User my_user  
      Port 5543  
      ```  
   2. Creamos nuestras credenciales para poder ingresar al servidor sin la necesidad de autenticarnos explicitamente,  
      generando una llave privada ```id_rsa``` y una llave publica ```id_rsa.pub``` de la siguiente manera :  
      ```ssh-keygen -b 4096 -t rsa```  
      
      Despues de generar as llaves, copiamos la llave pública al servidor remoto OWGIS:  
      ```ssh-copy-id  -i  ~/.ssh/id_rsa.pub  user@servidor```  
      
   Ahora ya podremos ejecutar el script sin la necesidad de autenticarnos explicitamente.

__Configuracion de nuestro manejador de base de datos__

Para poder generar los respaldos de las bases de datos en necesario que nuestro usuario tenga los permisos necesarios.  
  
  * En caso de no tener un usuario , hay que crearlo con los permisos necesarios  
  
  ```CREATE ROLE my_user_db WITH LOGIN SUPERUSER CREATEROLE CREATEDB PASSWORD 'my_pwd' VALID UNTIL 'infinity';  ```
  
  * Si el usuario no tiene los permisos entonces hay que asignarselos  
  
  ```ALTER ROLE my_user_db WITH LOGIN SUPERUSER CREATEROLE CREATEDB VALID UNTIL 'infinity'; ```  
  
__Crear un cronjob que genere los archivos de respaldos .sql__

Esto se hace para que despues con ```rsync``` respaldemos la carpeta en donde se encuantran los *archivos backup*  
de las diferentes bases de datos.  
Enonces en un archivo ```.sh``` ponemos lo siguiente:

  ``` 
      #!/bin/sh 
      pg_dump -v -h my_host -d data_base_1 -f /$PATH/respaldos/BasesDatos/data_base_backup_1.sql
      pg_dump -v -h my_host -d data_base_2 -f /$PATH/respaldos/BasesDatos/data_base_backup_2.sql
      .
      .
      .
  ```

Solo faltaria agregar nuestro script ```.sh``` a nuestro __cron__  

### Lista de archivos a respaldar

A continuación listamos una serie de carpetas que contienen los archivos que necesitamos:

  * var/www/html
  * ServerScripts
  * ServerData/OWGIS/Atlas
  * ServerData/OutTempRaul
  * ServerData/ncWMS_Layers
  * ServerData/DataFestData
  * ServerData/GeoserverCenapredLayers
  * ServerData/GeoserverCenapredData/styles
  * ServerData/GeoserverCenapredData/workspaces
  * ServerData/GeoserverLayers
  * ServerData/GeoserverData/styles
  * ServerData/GeoserverData/workspaces
  * ServerData/ViajandoDFData
  * ServerData/GeoserverViajandoDFData/workspaces
  * ServerData/GeoserverViajandoDFData/styles
  * ServerData/GeoserverDataCaro/styles
  * ServerData/GeoserverDataCaro/workspaces
  * ServerData/GeoserverDataBeatTheBeast/styles
  * ServerData/GeoserverDataBeatTheBeast/workspaces
  * owgisconfig/ncwms/config.xml
  * owgisconfig/ncwms/palettes
  
Estas son las bases de datos que vamos a respaldar que se encuentran en ```home/user/respaldos/BasesDatos/``` :  

  * contingencia
  * datafest
  * db_sms
  * maincca
  * pumabus
  * viajandodf
 
 ### Lista de archivos a omitir
 
 Estas carpetas contienen los archivos que no deseamos respaldar:
 
  * ServerScripts/LYDAR/images
  
## Probando
Para ejecutar el script se tiene que hacer lo siguiente desde una línea de comando:  
   `user@:~$ bash respaldo_auto.sh`  

 #### Descripción del script `` respaldo_auto.sh ``
 Este script en bash realiza los respaldos de la información que se necesita. 
 
 * Respaldamos la información listada en el archivo de texto ``archivos_a_respaldar.txt`` y omite respaldar el listado  
   de archivos que se encuantran en el archivo de texto ``archivos_a_omitir.txt``.
 
 ```
 rsync -avtbr -e 'ssh' --rsync-path='sudo rsync' --files-from='/$PATH_TXT/archivos_a_respaldar.txt'  
       --exclude-from='/$PATH_TXT/archivos_a_omitir.txt' --delete-excluded --filter='protect my_folder_backup*'  
       OWGIS_server:/  /$PATH_BACKUP/my_folder_backup
 ```
 Este es un ejemplo de como podría ser el archivo ``archivos_a_respaldar.txt`` en donde se respaldan todas las subcarpetas  
 y archivos contenidos en la carpeta *ServerScripts* y en la carpeta */html* :  
 
 ```
 var/www/html  
 ServerScripts 
 ```
 
 El siguiente ejemplo es del archivo ``archivos_a_omitir.txt`` en donde se listan las carpetas que se quieren ignorar al  
 momento de generar el respaldo, en este caso se quiere omitir los archivos que se encuentran en la subcarpeta */images* :  
  
 ```
 ServerScripts/LYDAR/images
 ```
 Hay que tener cuidado que las rutas que se especifican en los dos archivos de ejemplo son rutas absolutas.  
 
 * Respaldamos los archivos *backup* de las bases de datos.  

 ```
 rsync -avtbr --delete-excluded --filter='protect my_folder_backup*' OWGIS_server:/$PATH_REMOTE_DB /$PATH_BACKUP/my_folder_backup
 ```
 
 * Respaldamos los archivos del servidor ncWMS 
 ```
 rsync -avtbr --delete-excluded --min-size=100k --filter='protect my_folder_backup*' OWGIS_server:/$PATH_NCWMS/config.xml  /$PATH_BACKUP/my_folder_backup/my_folder_owgis_config
 ```
 
 * Respaldamos las paletas de colores
 ```
 rsync -avtbr --delete-excluded --filter='protect respaldo_*' OWGIS_server:/$PATH_NCWMS/palettes /$PATH_BACKUP/my_folder_backup/my_folder_owgis_config
 ```
 #### Opcional ####
 
 En nuestro caso particular se generan dos copias *config.xml.ayer* y *config.xml.antier* del archivo de configuración del  
 servidor NCWMS  *config.xml*. Para generar estos archivos se hace con el script [configBackup.sh](ncWMS_Config_Backup/configBackup.sh) y para que que estos  
 archivos se respalden se haría agregando las siguientes lineas al script.
 
 ```
 rsync -avtbr --delete-excluded --min-size=100k --filter='protect my_folder_backup*' OWGIS_server:/$PATH_NCWMS/config.xml.antier  /$PATH_BACKUP/my_folder_backup/my_folder_owgis_config
 ```
 
 ```
 rsync -avtbr --delete-excluded --min-size=100k --filter='protect my_folder_backup*' OWGIS_server:/$PATH_NCWMS/config.xml.ayer  /$PATH_BACKUP/my_folder_backup/my_folder_owgis_config
 ```
 
 #### Descripción del script ``respaldo_BD.sh``
  Este script genera los archivos _backup_ de las bases de datos que se quieren respaldar (Nota: este script debe de estar  
  en el cron de un usuario del servidor).
  Este es un ejemplo de como se respalda la base de datos *contingencia* en el archivo `sh` :  
    
      pg_dump -v -h localhost -d contingencia -f  /$PATH/BasesDatos/contingencia.sql 
     
## Construido con
* [Bash][1] Lenguaje de programación
* [Rsync][2] Usado para generar la sincronización de las carpetas.

## Versionando  
Usamos [SemVer][3] para versionar. Para las versiones disponibles, consulte [las etiquetas en este repositorio][4].

## Autores
* **Raúl Medina Peña** - [Github][5]

## Licencia
Este proyecto está licenciado bajo la licencia MIT; consulte el archivo [LICENSE](LICENSE) para obtener detalles.

## Agradecimientos  
* Agradecemos a [Olmo Zavala][6] por su colaboración y todo su apoyo en este proyecto.

[1]: https://www.gnu.org/software/bash/
[2]: http://rsync.samba.org/
[3]: https://semver.org/lang/es/
[4]: https://github.com/grupoioa/respaldo_automatizado/tags
[5]: https://github.com/rmedina09
[6]: https://github.com/olmozavala
