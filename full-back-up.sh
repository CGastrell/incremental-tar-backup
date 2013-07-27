#!/bin/bash

DATE=`date +%Y%m%d`

#Reemplazar las referencias de DIR por el directorio que quieran backupear
#Este script es el de full back up e inicialization de DIR.snar
#Solo deberia correrse cada N dias. Diariamente hacemos un incremental
# con el otro script.
#DIR.snar es el archivo de snapshot que vamos a usar con tar

#Paso 1
#Borramos todos los snar que haya en el directorio que usemos de 'workspace'
#Prefiero hacer esto en un directorio local y luego pasar las cosas
# a directorio backup para recoleccion/almacenamiento a largo plazo
#Usen el path que mas les convenga
rm /path/to/workspace/*snar

#Paso 2
#Para simplicidad me muevo al directorio padre del que quiero backupear
# && hago el tar.gz con listed-incremental a un DIR.snar, el nombre
#    del archivo tar lo hago con la fecha
# && muevo el archivo al directorio de recoleccion/almacenamiento
cd /path/to/dir/DIR && tar --listed-incremental /opt/backups/DIR.snar -czpf /path/to/workspace/DIR-$DATE-full.tar.gz DIR && mv /path/to/workspace/DIR-$DATE-full.tar.gz /backup

#Paso 3
#Con --listed-incremental se crea el archivo DIR.snar, 
# le hago una copia para siempre despues usar el nivel 0 de incremental
# (ver en el script incremental, se hace la copia al reves)
cp /path/to/workspace/DIR.snar /opt/backups/DIR.level0.snar
