#! /bin/bash

echo Removing Tropo Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/tropo \
-H "Content-type: application/json"
echo

