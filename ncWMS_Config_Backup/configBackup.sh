#!bin/bash

#Rutas originales
src=/usr/local/owgisconfig/ncwms
out=/usr/local/owgisconfig/ncwms


echo $(date)

#Obtenemos el tamaño del archivo de respaldo de un dia antes
tam_ayer=$(du -k $src/config.xml.ayer | cut -f1)

#En caso de que el tamaño del archivo config.xml sea mayor a 10K se respalda
if [ $tam_ayer -gt 10 ]; then
	cp $src/config.xml.ayer $out/config.xml.antier	
	if [ $? -eq 0 ]; then
		echo "copy config.xml.ayer ---> config.xml.antier Success!!!"
	fi
fi

#Nos esperamos 3 segundo para que primero se respalde config.xml y despues config.xml.ayer
sleep 3

#Obtenemos el tamaño de el archivo config.xml (el archivo de actual)
tam_hoy=$(du -k $src/config.xml | cut -f1)

#En caso de que el tamaño del archivo config.xml.ayer sea mayor a 10K se respalda
if [ $tam_hoy -gt 10 ]; then
	cp $src/config.xml $out/config.xml.ayer
	if [ $? -eq 0 ]; then
		echo "copy config.xml ---> config.xml.ayer Success!!!"
	fi
fi
