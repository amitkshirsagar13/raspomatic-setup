#!/bin/sh

storage=$1
logUrl="$2"
url="$2XINDEX.jpg"
start=$3
end=$4
logStorage=${logUrl##*/}
if [ ! -d "$storage/$logStorage" ]; then
    echo "Creating $storage"
    mkdir -p $storage/$logStorage
else
    logStorage=$logStorage`date +%m%d%H%M`
    echo "Creating $storage"
    mkdir -p $storage/$logStorage
fi

while [ $start -lt $end ]
do
    downloadUrl="${url//XINDEX/$start}"
    wget –-quiet $downloadUrl -P $storage/$logStorage >> $storage/0.$logStorage.log
    true $(( start++ ))
done
