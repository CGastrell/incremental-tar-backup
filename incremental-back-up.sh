#!/bin/bash

DATE=`date +%Y%m%d`

#Este checkeo lo hago solo para ver si existe un incremental
if [ -f /path/to/workspace/DIR.level0.snar ]; then
  #copio el level 0 de incremental, si no lo hiciera
  #para recuperar un estado del DIR tendria que 
  #extraer incremental por incremental hasta el momento que quiera
  #de esta forma, solo extraigo el full y el que quiero restaurar
  cp /path/to/workspace/DIR.level0.snar /path/to/workspace/DIR.snar
  
  #Por practicidad me muevo al directorio que contiene a DIR
  # && hago tar con incremental y lo grabo con nombre diferencial
  # && lo muevo al directorio de recoleccion/almacenamiento
  cd /path/to/dir && tar --listed-incremental /path/to/workspace/DIR.snar -czpf /path/to/workspace/DIR-$DATE-incremental.tar.gz DIR && mv /path/to/workspace/DIR-$DATE-incremental.tar.gz /backup
fi

# para recuperar un backup incremental hay que tirar:
# tar -xzpf ARCHIVO_BACKUP_FULL.tar.gz
# tar -xzpf ARCHIVO_INCREMENTAL.tar.gz
#
# ej:
# tar -xzpf IPGH-[FECHA_ACA]-full.tar.gz
# tar -xzpf IPGH-[FECHA_RESTORE_DESEADA_ACA]-incremental.tar.gz
