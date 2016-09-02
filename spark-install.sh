#! /bin/bash

echo
echo "Thank you for using the MyHero Demo Application."
echo "This script will install the Spark Bot Microservice. "
echo "for a basic installation. "
echo
echo "Reminder, in order to leverage myhero_spark, your Mantl "
echo "environment MUST be accessible from the Public Internet. "
echo "If your Mantl cluster is deployed in an internal lab, not "
echo "publically accessible, this service will not work."
echo
echo "Press Enter to continue..."
read confirm
echo


[ -z "${MANTL_CONTROL}" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "${MANTL_USER}" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "${MANTL_PASSWORD}" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "${MANTL_DOMAIN}" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "${DEPLOYMENT_NAME}" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

[ -z "${SPARK_EMAIL}" ] && echo "Please run 'source spark_setup' to set Environment Variables" && exit 1;
[ -z "${SPARK_TOKEN}" ] && echo "Please run 'source spark_setup' to set Environment Variables" && exit 1;

set -euo pipefail

# Create Copy of JSON Definitions for Deployment
echo "Creating Service Definifition "

cp templates/sample-myhero-spark.json app_definitions/${DEPLOYMENT_NAME}-spark.json
sed -i -e "s/DEPLOYMENTNAME/${DEPLOYMENT_NAME}/g" app_definitions/${DEPLOYMENT_NAME}-spark.json
sed -i -e "s/MANTLDOMAIN/${MANTL_DOMAIN}/g" app_definitions/${DEPLOYMENT_NAME}-spark.json
sed -i -e "s/SPARKEMAIL/${SPARK_EMAIL}/g" app_definitions/${DEPLOYMENT_NAME}-spark.json
sed -i -e "s/SPARKTOKEN/${SPARK_TOKEN}/g" app_definitions/${DEPLOYMENT_NAME}-spark.json
sed -i -e "s/TAG/${TAG}/g" app_definitions/${DEPLOYMENT_NAME}-spark.json
echo "     myhero_spark service:   app_definitions/${DEPLOYMENT_NAME}-spark.json"


echo " "
echo "***************************************************"
echo Deploying Spark Service
curl -k -X POST -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps \
-o /dev/null \
-H "Content-type: application/json" \
-d @app_definitions/${DEPLOYMENT_NAME}-spark.json
echo "***************************************************"
echo

echo Deployed
echo " "
echo "Wait 3-5 minutes for the service to deploy "
echo " "
echo "To have the Bot send a message to a user, run this command "
echo " "
echo "    curl -H \"key: SecureBot\" http://${DEPLOYMENT_NAME}-spark.${MANTL_DOMAIN}/hello/<emailaddress>"
echo " "


