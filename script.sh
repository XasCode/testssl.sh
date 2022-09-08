#!/bin/bash

PROJECT=$(/root/google-cloud-sdk/bin/gcloud compute project-info describe | grep "name: " | sed --expression='s/name: //g')

/root/google-cloud-sdk/bin/gsutil cp gs://${PROJECT}-results/queue/* ./
FILES=$(/root/google-cloud-sdk/bin/gsutil ls gs://${PROJECT}-results/queue/*)

for i in $FILES; do 
  /root/google-cloud-sdk/bin/gsutil rm $i
done

for j in $FILES; do 
  rm -f /home/testssl/out.json
  HOSTNAME=$(cat $(basename $j) | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | grep "\"host\"" | cut -f 4 -d '"')
  /home/testssl/testssl.sh -oJ /home/testssl/out.json $HOSTNAME
  /root/google-cloud-sdk/bin/gsutil cp /home/testssl/out.json gs://${PROJECT}-results/$(basename $j)
done