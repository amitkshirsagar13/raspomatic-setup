#!/bin/sh

storage=$1
url="$2XINDEX.jpg"
start=$3
end=$4

if [ ! -d "$storage" ]; then
    echo "Creating $storage"
    mkdir $storage
fi

while [ $start -lt $end ]
do
    downloadUrl="${url//XINDEX/$start}"
    wget $downloadUrl -P $storage > 
    true $(( start++ ))
done
