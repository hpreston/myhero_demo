#! /bin/bash

[ -z "$MANTL_CONTROL" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_USER" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_PASSWORD" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_DOMAIN" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

[ -z "$SPARK_EMAIL" ] && echo "Please run 'source spark_setup' to set Environment Variables" && exit 1;
[ -z "$SPARK_TOKEN" ] && echo "Please run 'source spark_setup' to set Environment Variables" && exit 1;



echo Deploying Spark Service
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @myhero-spark.json

curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/spark?force=true \
-H "Content-type: application/json" \
-d "{\"env\": {\"myhero_app_server\": \"http://myhero-app.$MANTL_DOMAIN\", \"myhero_app_key\": \"SecureApp\", \"myhero_spark_bot_email\": \"$SPARK_EMAIL\", \"spark_token\": \"$SPARK_TOKEN\", \"myhero_spark_bot_url\": \"http://myhero-spark.$MANTL_DOMAIN\", \"myhero_spark_bot_secret\": \"SecureBot\"}}"


echo ***************************************************
echo


echo Deployed

