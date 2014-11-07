#!/bin/bash

# Usage instructions
# ./analyzer.sh
#
# Input:
# Looks for .tar.gz files placed in ./logs directory for analysis
#
# Output:
# Places results in ./tmp

# where data is put during processing
DATA_DIR="./tmp"

# clean-up old data
rm -fr $DATA_DIR
mkdir -p $DATA_DIR

## unzip logs to data directory
for f in $(find . -iname "*.tar.gz")
do
  tar --overwrite --directory=$DATA_DIR -xf $f
done

## clean-up logs in data directory for how we will need them
pushd $DATA_DIR/var/log/openshift/broker/upgrade

# remove time-stamped files
rm -fr *upgrade_errors*_2*

# format error logs
for f in $(find . -iname "upgrade_errors_*")
do
  while read line; do 
    echo $line | python -mjson.tool >> $f.json; 
  done < $f
done

# clean-up irrelevant data [we only want the json files]
ls | grep -v .json | xargs -n1 -IREPLACE rm -rf REPLACE

popd
