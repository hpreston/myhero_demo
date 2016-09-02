#! /bin/bash

echo
echo "Thank you for using the MyHero Demo Application."
echo "This script will uninstall the MyHero services deployed. "
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

echo Removing UI Service
curl -k -X DELETE -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps/${DEPLOYMENT_NAME}/ui \
-H "Content-type: application/json"
echo

echo Removing Web Service
curl -k -X DELETE -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps/${DEPLOYMENT_NAME}/web \
-H "Content-type: application/json"
echo

echo Removing Tropo Service
curl -k -X DELETE -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps/${DEPLOYMENT_NAME}/tropo \
-H "Content-type: application/json"
echo

echo Removing Spark Service
curl -k -X DELETE -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps/${DEPLOYMENT_NAME}/spark \
-H "Content-type: application/json"
echo

echo Removing App Service
curl -k -X DELETE -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps/${DEPLOYMENT_NAME}/app \
-H "Content-type: application/json"
echo

echo Removing Ernst Service
curl -k -X DELETE -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps/${DEPLOYMENT_NAME}/ernst \
-H "Content-type: application/json"
echo

echo Removing Mosca
curl -k -X DELETE -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps/${DEPLOYMENT_NAME}/mosca \
-H "Content-type: application/json"
echo

echo Removing Data Service
curl -k -X DELETE -u ${MANTL_USER}:${MANTL_PASSWORD} https://${MANTL_CONTROL}/v2/apps/${DEPLOYMENT_NAME}/data \
-H "Content-type: application/json"
echo

