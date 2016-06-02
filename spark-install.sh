#! /bin/bash

[ -z "$MANTL_CONTROL" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_USER" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_PASSWORD" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_DOMAIN" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$DEPLOYMENT_NAME" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

[ -z "$SPARK_EMAIL" ] && echo "Please run 'source spark_setup' to set Environment Variables" && exit 1;
[ -z "$SPARK_TOKEN" ] && echo "Please run 'source spark_setup' to set Environment Variables" && exit 1;

# Create Copy of JSON Definitions for Deployment
echo "Creating Service Definifition "

cp sample-myhero-spark.json $DEPLOYMENT_NAME-spark.json
sed -i "" -e "s/DEPLOYMENTNAME/$DEPLOYMENT_NAME/g" $DEPLOYMENT_NAME-spark.json
sed -i "" -e "s/MANTLDOMAIN/$MANTL_DOMAIN/g" $DEPLOYMENT_NAME-spark.json
sed -i "" -e "s/SPARKEMAIL/$SPARK_EMAIL/g" $DEPLOYMENT_NAME-spark.json
sed -i "" -e "s/SPARKTOKEN/$SPARK_TOKEN/g" $DEPLOYMENT_NAME-spark.json


echo " "
echo "***************************************************"
echo Deploying Spark Service
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @$DEPLOYMENT_NAME-spark.json \
| python -m json.tool

echo "***************************************************"
echo

echo Deployed
echo " "
echo "Wait 5-10 minutes for the service to deploy "
echo "and then run the following command to list members of the room."
echo " "
echo "    curl -H \"key: SecureBot\" http://$DEPLOYMENT_NAME-spark.$MANTL_DOMAIN/demoroom/members"
echo " "
echo "To add a member ot the room, run this command "
echo " "
echo "    curl -X PUT -H \"key: SecureBot\" http://$DEPLOYMENT_NAME-spark.$MANTL_DOMAIN/demoroom/members -d '{\"email\":\"<emailaddress>\"}' "
echo " "


