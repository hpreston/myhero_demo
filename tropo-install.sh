#! /bin/bash

[ -z "$MANTL_CONTROL" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_USER" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_PASSWORD" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_DOMAIN" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$DEPLOYMENT_NAME" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

[ -z "$TROPO_USER" ] && echo "Please run 'source tropo_setup' to set Environment Variables" && exit 1;
[ -z "$TROPO_PASS" ] && echo "Please run 'source tropo_setup' to set Environment Variables" && exit 1;
[ -z "$TROPO_PREFIX" ] && echo "Please run 'source tropo_setup' to set Environment Variables" && exit 1;

echo "***************************************************"
echo Checking if Prefix Is Valid
python tropo_utils.py numbercheck $TROPO_PREFIX

if [ $? -eq 1 ]
then
    echo "    Provided Prefix is invalid, please try a different one."
    echo "    Here are some possible options to try."
    python tropo_utils.py listprefixes 10
    echo "    To try a different prefix."
    echo "      1) export TROPO_PREFIX=<new prefix>"
    echo "      2) ./tropo-install.sh"
    exit 1
else
    echo "    Application Prefix is Valid"
fi

# Create Copy of JSON Definitions for Deployment
echo "Creating Service Definifition "

cp sample-myhero-tropo.json $DEPLOYMENT_NAME-tropo.json
sed -i "" -e "s/DEPLOYMENTNAME/$DEPLOYMENT_NAME/g" $DEPLOYMENT_NAME-tropo.json
sed -i "" -e "s/MANTLDOMAIN/$MANTL_DOMAIN/g" $DEPLOYMENT_NAME-tropo.json
sed -i "" -e "s/TROPOUSER/$TROPO_USER/g" $DEPLOYMENT_NAME-tropo.json
sed -i "" -e "s/TROPOPASS/$TROPO_PASS/g" $DEPLOYMENT_NAME-tropo.json
sed -i "" -e "s/TROPOPREFIX/$TROPO_PREFIX/g" $DEPLOYMENT_NAME-tropo.json

echo Checking if Tropo Application Called "myherodemo" exists already.
python tropo_utils.py applicationcheck myherodemo

if [ $? -eq 0 ]
then
    echo "    Exisiting Application Found, will update and use it."
else
    echo "    No existing application found. A new one will be created after the service is deployed."
fi
echo " "
echo "***************************************************"
echo Deploying Tropo Service
echo " "
echo "** Marathon Application Definition ** "
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @$DEPLOYMENT_NAME-tropo.json \
| python -m json.tool


echo Deployed
echo " "
echo "Wait 5-10 minutes for the service to deploy "
echo "and then run the following command to find your number."
echo " "
echo "    curl -H \"key: SecureTropo\" http://$DEPLOYMENT_NAME-tropo.$MANTL_DOMAIN/application/number"
echo " "
echo " "

