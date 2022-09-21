#!/bin/bash

cd /home/testssl

PROJECT=$(gcloud compute project-info describe | grep "name: " | sed --expression='s/name: //g')

gsutil cp gs://${PROJECT}-step/root_ca.crt /home/testssl/root_ca.crt

gsutil cp gs://${PROJECT}-results/queue/* ./
FILES=$(gsutil ls gs://${PROJECT}-results/queue/*)

for i in $FILES; do 
  gsutil rm $i
done

for j in $FILES; do 
  rm -f /home/testssl/out.json
  HOSTNAME=$(cat $(basename $j) | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | grep "\"host\"" | cut -f 4 -d '"')
  /home/testssl/testssl.sh --add-ca /home/testssl/root_ca.crt -oJ /home/testssl/out.json $HOSTNAME
  gsutil cp /home/testssl/out.json gs://${PROJECT}-results/$(basename $j)
done