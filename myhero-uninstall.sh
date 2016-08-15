#! /bin/bash

[ -z "$MANTL_CONTROL" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_USER" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_PASSWORD" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_DOMAIN" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$DEPLOYMENT_NAME" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

echo Removing Web Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD $MARATHON_URL/v2/apps/$DEPLOYMENT_NAME/web \
-H "Content-type: application/json"
echo

echo Removing App Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD $MARATHON_URL/v2/apps/$DEPLOYMENT_NAME/app \
-H "Content-type: application/json"
echo


echo Removing Data Service
curl -k -X DELETE -u $MANTL_USER:$MANTL_PASSWORD $MARATHON_URL/v2/apps/$DEPLOYMENT_NAME/data \
-H "Content-type: application/json"
echo

