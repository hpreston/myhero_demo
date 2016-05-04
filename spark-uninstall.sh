#! /bin/bash

echo Removing Spark Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/spark \
-H "Content-type: application/json"
echo

