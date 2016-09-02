#! /bin/bash

echo
echo "Thank you for using the MyHero Demo Application."
echo "This script will install all of the Microservices needed, "
echo "for a basic installation. "
echo
echo "Press Enter to continue..."
read confirm
echo

[ -z "${MANTL_CONTROL}" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "${MANTL_USER}" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "${MANTL_PASSWORD}" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "${MANTL_DOMAIN}" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "${DEPLOYMENT_NAME}" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

set -euo pipefail


echo " "
echo "************************************************************************************************"
echo Checking if MyHero has already been deployed with deployment name \"${DEPLOYMENT_NAME}\"
if python mantl_utils.py applicationexists ${DEPLOYMENT_NAME}/ui; then
    echo "    Deployment name already used."
    echo "    Rerun 'source myhero_setup' and choose a new deployment name."
    exit 1
else
    echo "    Deployment name available, continuing."
fi


echo "************************************************************************************************"
# Create Copy of JSON Definitions for Deployment
echo "Creating Marathon Service Definitions for each service."

cp templates/sample-myhero-data.json app_definitions/${DEPLOYMENT_NAME}-data.json
sed -i -e "s/DEPLOYMENTNAME/${DEPLOYMENT_NAME}/g" app_definitions/${DEPLOYMENT_NAME}-data.json
sed -i -e "s/MANTLDOMAIN/${MANTL_DOMAIN}/g" app_definitions/${DEPLOYMENT_NAME}-data.json
sed -i -e "s/TAG/${TAG}/g" app_definitions/${DEPLOYMENT_NAME}-data.json
echo "     myhero_data service:   app_definitions/${DEPLOYMENT_NAME}-data.json"

cp templates/sample-myhero-mosca.json app_definitions/${DEPLOYMENT_NAME}-mosca.json
sed -i -e "s/DEPLOYMENTNAME/${DEPLOYMENT_NAME}/g" app_definitions/${DEPLOYMENT_NAME}-mosca.json
sed -i -e "s/MANTLDOMAIN/${MANTL_DOMAIN}/g" app_definitions/${DEPLOYMENT_NAME}-mosca.json
sed -i -e "s/TAG/${TAG}/g" app_definitions/${DEPLOYMENT_NAME}-mosca.json
echo "     myhero_mosca service:  app_definitions/${DEPLOYMENT_NAME}-mosca.json"

cp templates/sample-myhero-app.json app_definitions/${DEPLOYMENT_NAME}-app.json
sed -i -e "s/DEPLOYMENTNAME/${DEPLOYMENT_NAME}/g" app_definitions/${DEPLOYMENT_NAME}-app.json
sed -i -e "s/MANTLDOMAIN/${MANTL_DOMAIN}/g" app_definitions/${DEPLOYMENT_NAME}-app.json
sed -i -e "s/direct/queue/g" app_definitions/${DEPLOYMENT_NAME}-app.json
sed -i -e "s/TAG/${TAG}/g" app_definitions/${DEPLOYMENT_NAME}-app.json
echo "     myhero_app service:    app_definitions/${DEPLOYMENT_NAME}-app.json"

cp templates/sample-myhero-ernst.json app_definitions/${DEPLOYMENT_NAME}-ernst.json
sed -i -e "s/DEPLOYMENTNAME/${DEPLOYMENT_NAME}/g" app_definitions/${DEPLOYMENT_NAME}-ernst.json
sed -i -e "s/MANTLDOMAIN/${MANTL_DOMAIN}/g" app_definitions/${DEPLOYMENT_NAME}-ernst.json
sed -i -e "s/TAG/${TAG}/g" app_definitions/${DEPLOYMENT_NAME}-ernst.json
echo "     myhero_ernst service:  app_definitions/${DEPLOYMENT_NAME}-ernst.json"


cp templates/sample-myhero-ui.json app_definitions/${DEPLOYMENT_NAME}-ui.json
sed -i -e "s/DEPLOYMENTNAME/${DEPLOYMENT_NAME}/g" app_definitions/${DEPLOYMENT_NAME}-ui.json
sed -i -e "s/MANTLDOMAIN/${MANTL_DOMAIN}/g" app_definitions/${DEPLOYMENT_NAME}-ui.json
sed -i -e "s/TAG/${TAG}/g" app_definitions/${DEPLOYMENT_NAME}-ui.json
echo "     myhero_ui service:     app_definitions/${DEPLOYMENT_NAME}-ui.json"

#cp templates/sample-myhero-web.json app_definitions/${DEPLOYMENT_NAME}-web.json
#sed -i -e "s/DEPLOYMENTNAME/${DEPLOYMENT_NAME}/g" app_definitions/${DEPLOYMENT_NAME}-web.json
#sed -i -e "s/MANTLDOMAIN/${MANTL_DOMAIN}/g" app_definitions/${DEPLOYMENT_NAME}-web.json
#sed -i -e "s/TAG/${TAG}/g" app_definitions/${DEPLOYMENT_NAME}-web.json
#echo "     myhero_web service:    app_definitions/${DEPLOYMENT_NAME}-web.json"

echo " "
echo "************************************************************************************************"
echo Deploying Data Service
curl -k -X POST -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps \
-o /dev/null \
-H "Content-type: application/json" \
-d @app_definitions/${DEPLOYMENT_NAME}-data.json
echo "************************************************************************************************"
echo

echo Deploying Mosca
curl -k -X POST -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps \
-o /dev/null \
-H "Content-type: application/json" \
-d @app_definitions/${DEPLOYMENT_NAME}-mosca.json
echo "************************************************************************************************"
echo

echo 'Pausing for 30 seconds initial service startup...'
sleep 30

echo Deploying Application Service
curl -k -X POST -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps \
-o /dev/null \
-H "Content-type: application/json" \
-d @app_definitions/${DEPLOYMENT_NAME}-app.json
echo "************************************************************************************************"
echo

echo Deploying Ernst Service
curl -k -X POST -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps \
-o /dev/null \
-H "Content-type: application/json" \
-d @app_definitions/${DEPLOYMENT_NAME}-ernst.json
echo "************************************************************************************************"
echo

echo 'Pausing for 30 seconds API layer startup...'
sleep 30

#echo Deploying Web Service
#curl -k -X POST -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps \
#-o /dev/null \
#-H "Content-type: application/json" \
#-d @app_definitions/${DEPLOYMENT_NAME}-web.json
#echo "************************************************************************************************"
#echo

echo Deploying UI Service
curl -k -X POST -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps \
-o /dev/null \
-H "Content-type: application/json" \
-d @app_definitions/${DEPLOYMENT_NAME}-ui.json
echo
echo "************************************************************************************************"
echo


echo Deployed
echo " "
echo "Wait 3-5 minutes for the service to deploy "
echo "and then open the following page in your browser to view the application."
echo " "
echo "    http://${DEPLOYMENT_NAME}-ui.${MANTL_DOMAIN} "
echo " "
echo " "

