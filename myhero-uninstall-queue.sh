#! /bin/bash

echo Removing Web Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/mq/web \
-H "Content-type: application/json"
echo

echo Removing App Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/mq/app \
-H "Content-type: application/json"
echo

echo Removing Ernst Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/mq/ernst \
-H "Content-type: application/json"
echo

echo Removing Mosca
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/mq/mosca \
-H "Content-type: application/json"
echo


echo Removing Data Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/mq/data \
-H "Content-type: application/json"
echo

