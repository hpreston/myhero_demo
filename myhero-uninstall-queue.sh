#! /bin/bash

echo Removing Web Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/web \
-H "Content-type: application/json"
echo

echo Removing App Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/app \
-H "Content-type: application/json"
echo

echo Removing Ernst Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/ernst \
-H "Content-type: application/json"
echo

echo Removing Mosca
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/mosca \
-H "Content-type: application/json"
echo


echo Removing Data Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/data \
-H "Content-type: application/json"
echo

