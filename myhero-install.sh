#! /bin/bash

set -euo pipefail

[ -z "$MANTL_CONTROL" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_USER" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_PASSWORD" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_DOMAIN" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$DEPLOYMENT_NAME" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

echo " "
echo "***************************************************"
echo Checking if MyHero has already been deployed with deployment name \"$DEPLOYMENT_NAME\"
if python mantl_utils.py applicationexists $DEPLOYMENT_NAME/web; then
    echo "    Deployment name already used."
    echo "    Rerun 'source myhero_setup' and choose a new deployment name."
    exit 1
else
    echo "    Deployment name available, continuing."
fi

# Create Copy of JSON Definitions for Deployment
echo "Creating Service Definifition "

cp sample-myhero-app.json ${DEPLOYMENT_NAME}-app.json
sed -i "" -e "s/DEPLOYMENTNAME/${DEPLOYMENT_NAME}/g" ${DEPLOYMENT_NAME}-app.json
sed -i "" -e "s/MANTLDOMAIN/$MANTL_DOMAIN/g" ${DEPLOYMENT_NAME}-app.json
sed -i "" -e "s/TAG/$TAG/g" ${DEPLOYMENT_NAME}-app.json


cp sample-myhero-data.json ${DEPLOYMENT_NAME}-data.json
sed -i "" -e "s/DEPLOYMENTNAME/${DEPLOYMENT_NAME}/g" ${DEPLOYMENT_NAME}-data.json
sed -i "" -e "s/TAG/$TAG/g" ${DEPLOYMENT_NAME}-data.json

cp sample-myhero-web.json ${DEPLOYMENT_NAME}-web.json
sed -i "" -e "s/DEPLOYMENTNAME/${DEPLOYMENT_NAME}/g" ${DEPLOYMENT_NAME}-web.json
sed -i "" -e "s/MANTLDOMAIN/$MANTL_DOMAIN/g" ${DEPLOYMENT_NAME}-web.json
sed -i "" -e "s/TAG/$TAG/g" ${DEPLOYMENT_NAME}-web.json


echo " "
echo "***************************************************"
echo Deploying Data Service
echo "** Marathon Application Definition ** "
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD $MARATHON_URL/v2/apps \
-H "Content-type: application/json" \
-d @${DEPLOYMENT_NAME}-data.json \
| python -m json.tool
echo "***************************************************"
echo

sleep 7

echo Deploying Application Service
echo "** Marathon Application Definition ** "
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD $MARATHON_URL/v2/apps \
-H "Content-type: application/json" \
-d @${DEPLOYMENT_NAME}-app.json \
| python -m json.tool
echo
echo "***************************************************"
echo

sleep 7

echo Deploying Web Service
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD $MARATHON_URL/v2/apps \
-H "Content-type: application/json" \
-d @${DEPLOYMENT_NAME}-web.json \
| python -m json.tool
echo
echo "***************************************************"
echo

echo Deployed
echo " "
echo "Wait 5-10 minutes for the service to deploy "
echo "and then open the following page in your browser to view the application."
echo " "
echo "    http://${DEPLOYMENT_NAME}-web.$MANTL_DOMAIN "
echo " "
echo " "

