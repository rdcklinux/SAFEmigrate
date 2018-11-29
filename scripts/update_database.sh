#!/bin/bash
script=$1;

cat "$script" > upxe.sql;
echo '' >> upxe.sql;
echo '' >> upxe.sql;
echo 'quit;' >> upxe.sql;

sudo docker cp upxe.sql oracle:/tmp;
rm upxe.sql;
sudo docker exec -it oracle sqlplus SAFE/safe @/tmp/upxe.sql

