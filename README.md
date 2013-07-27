incremental-tar-backup
======================

Bash script para backups incrementales


Configuración/Implementación
============================

Reemplazar en los scripts las referencias a:

* <code>DIR</code>: el directorio que queremos backupear
* <code>/path/to/dir</code>: la ruta al directorio que CONTIENE a <code>DIR</code>
* <code>/path/to/workspace</code>: la ruta a un directorio que usemos temporalmente para alojar los tar/snar
* <code>/backup</code>: un directorio donde se alojan los backups, probablemente un servidor de almacenamiento montado en un directorio local
* <code>DATE</code>: una variable que declaro para tener referencia de la fecha y usarla en los nombres de los archivos (no es necesario cambiarla)

Correr por primera vez el script full-backup.sh a mano para inicializar los archivos incrementales y el snapshot.


Uso típico
==========

Estos scripts sirven principalmente para guardar estados de un directorio de manera incremental.
Dicho de otra manera, podemos armar estos scripts para que hagan backup de un sitio que tenemos
publicado sin tener que copiar todos los archivos, solo los que hayan cambiado.
Ejemplo de las variables de referencia:

* <code>DIR</code>: /var/www/misitio
* <code>/path/to/dir</code>: /var/www
* <code>/path/to/workspace</code>: /var/backups/sitioweb
* <code>/backup</code>: /mount/backupserverNFS


Crontab
=======

Para que estos scripts tengan sentido habrá que ponerlos en el [cron](https://en.wikipedia.org/wiki/Cron).

Hay que estar atento que la cuenta que genere el crontab tenga permisos de lectura/escritura en los directorios
correspondientes.

Luego, el backup full no queremos correrlo muy seguido, en mi caso es cada 10 días a las 3AM (o, según dicen, cada vez que el
día del mes es múltiplo de 10). Ej:

<pre>
0 3 */10 * * /path/to/full-backup.sh
</pre>

Y para que el incremental se corra todos los días a las 4AM:

<pre>
0 4 * * * /path/to/incremental-backup.sh
</pre>

Es importante que corras la primera vez el full-backup.sh a mano (no esperes que lo haga el cron).


Incremental simple vs incremental por niveles
=============================================

El incremental del [tar](https://en.wikipedia.org/wiki/Tar_(computing)) se puede usar de 2 maneras:

* Creando incrementales directos sobre un full back up (simple)
* Creando niveles de incrementales (menos simple)

En el primer caso, se hace un incremental usando el parametro <code>--listed-incremental</code> y un archivo de
snapshot (.snar) que se encarga de comparar y definir las diferencias para incluir en el incremental. Para restaurar
<code>DIR</code> bastará con extraer el full backup y luego el de la fecha a restaurar.

<pre>
tar -xzpf DIR-20130720-full.tar.gz
tar -xzpf DIR-20130724-incremental.tar.gz
</pre>

En el segundo, el incremental se hace siempre sobre otro incremental. Si bien esta forma da más control sobre
el incremental y el tamaño de archivo, cuando se quiere restaurar <code>DIR</code> habrá que hacerlo secuencialmente
como están hechos los incrementales. Ejemplo considerando que tenemos 4 incrementales:

<pre>
tar -xzpf DIR-20130720-full.tar.gz
tar -xzpf DIR-20130721-incremental.tar.gz
tar -xzpf DIR-20130722-incremental.tar.gz
tar -xzpf DIR-20130723-incremental.tar.gz
tar -xzpf DIR-20130724-incremental.tar.gz
</pre>
