#!/bin/bash

cd $(dirname $0);cd ..;script_dir=$(pwd);
echo $script_dir;

for sql in $(ls -1 $script_dir/upgrades); do
  scripts/update_database.sh "upgrades/$sql";
done;

