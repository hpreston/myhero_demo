#! /bin/bash

[ -z "$MANTL_CONTROL" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_USER" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_PASSWORD" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_DOMAIN" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

echo " "
echo "***************************************************"
echo Deploying Data Service
echo "** Marathon Application Definition ** "
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @myhero-data.json \
| python -m json.tool
echo "***************************************************"
echo

echo Deploying Mosca
echo "** Marathon Application Definition ** "
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @myhero-mosca.json \
| python -m json.tool
echo "***************************************************"
echo

echo Deploying Ernst Service
echo "** Marathon Application Definition ** "
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @myhero-ernst.json \
| python -m json.tool
echo "Updating Ernst Service Environment Variables"
curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/ernst?force=true \
-H "Content-type: application/json" \
-d "{\"env\": {\"myhero_data_server\": \"http://myhero-data.$MANTL_DOMAIN\", \"myhero_data_key\": \"SecureData\", \"myhero_mqtt_server\": \"mosca-myhero.service.consul\"}}" \
| python -m json.tool
echo "***************************************************"
echo


echo Deploying Application Service
echo "** Marathon Application Definition ** "
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @myhero-app.json \
| python -m json.tool
echo "Updating App Service Environment Variables"
curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/app?force=true \
-H "Content-type: application/json" \
-d "{\"env\": {\"myhero_data_server\": \"http://myhero-data.$MANTL_DOMAIN\", \"myhero_data_key\": \"SecureData\", \"myhero_app_key\": \"SecureApp\", \"myhero_mqtt_server\": \"mosca-myhero.service.consul\", \"myhero_app_mode\": \"queue\"}}" \
| python -m json.tool
echo "***************************************************"
echo

echo Deploying Web Service
echo "** Marathon Application Definition ** "
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @myhero-web.json \
| python -m json.tool
echo "Updating Web Service Environment Variables"
curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/web?force=true \
-H "Content-type: application/json" \
-d "{\"env\": {\"myhero_app_server\": \"http://myhero-app.$MANTL_DOMAIN\", \"myhero_app_key\": \"SecureApp\"}}" \
| python -m json.tool
echo "***************************************************"
echo

echo Deployed
echo " "
echo "Wait 5-10 minutes for the service to deploy "
echo "and then open the following page in your browser to view the application."
echo " "
echo "    http://myhero-web.$MANTL_DOMAIN "
echo " "
echo " "

