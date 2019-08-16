#!/bin/sh

storage=$1
logUrl="$2"
url="$2XINDEX.jpg"
start=$3
end=$4
logStorage=${logUrl##*/}
if [ ! -d "$storage" ]; then
    echo "Creating $storage"
    mkdir $storage
fi

while [ $start -lt $end ]
do
    downloadUrl="${url//XINDEX/$start}"
    wget $downloadUrl -P $storage/$logStorage >> $storage/0.$logStorage.log
    true $(( start++ ))
done
