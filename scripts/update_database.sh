#!/bin/bash
script=$1;

cat "$script" > upxe.sql;
echo '' >> upxe.sql;
echo '' >> upxe.sql;
echo 'quit;' >> upxe.sql;

sudo docker cp upxe.sql oracle:/tmp;
rm upxe.sql;
sudo docker exec -it oracle env NLS_LANG=SPANISH_CHILE.AL32UTF8 sqlplus SAFE/safe @/tmp/upxe.sql

