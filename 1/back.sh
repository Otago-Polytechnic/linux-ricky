#!/bin/bash

echo "Absolute path of backup file"
read filePath
if [ -z "${filePath}" ];then
	filePath='./work'
fi

echo "Remote IP"
read ip1

echo "account"
read account


echo "rangeUrl"
read rangeUrl

tar -czvf work.tar.gz ./work
echo "tar success"
scp ./work.tar.gz $account@$ip1:$rangeUrl
echo "scp success"



