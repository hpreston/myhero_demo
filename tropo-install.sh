#! /bin/bash

[ -z "$MANTL_CONTROL" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_USER" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_PASSWORD" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_DOMAIN" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

[ -z "$TROPO_USER" ] && echo "Please run 'source tropo_setup' to set Environment Variables" && exit 1;
[ -z "$TROPO_PASS" ] && echo "Please run 'source tropo_setup' to set Environment Variables" && exit 1;
[ -z "$TROPO_PREFIX" ] && echo "Please run 'source tropo_setup' to set Environment Variables" && exit 1;


echo Deploying Tropo Service
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @myhero-tropo.json

curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/tropo?force=true \
-H "Content-type: application/json" \
-d "{\"env\": {\"myhero_app_server\": \"http://myhero-app.$MANTL_DOMAIN\", \"myhero_app_key\": \"SecureApp\", \"myhero_tropo_secret\": \"SecureTropo\", \"myhero_tropo_user\":\"$TROPO_USER\", \"myhero_tropo_pass\":\"$TROPO_PASS\", \"myhero_tropo_prefix\":\"$TROPO_PREFIX\", \"myhero_tropo_url\":\"http://myhero-tropo.$MANTL_DOMAIN\"}}"


echo ***************************************************
echo


echo Deployed

