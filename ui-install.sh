#! /bin/bash

[ -z "$MANTL_CONTROL" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_USER" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_PASSWORD" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_DOMAIN" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$DEPLOYMENT_NAME" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

echo " "
echo "***************************************************"
echo Checking if MyHero has already been deployed with deployment name \"$DEPLOYMENT_NAME\"
python mantl_utils.py applicationexists $DEPLOYMENT_NAME/ui
if [ $? -eq 1 ]
then
    echo "    Deployment name available, continuing."
else
    echo "    Deployment name already used."
    echo "    Rerun 'source myhero_setup' and choose a new deployment name."
    exit 1
fi

# Create Copy of JSON Definitions for Deployment
echo "Creating Service Definifition "

cp sample-myhero-ui.json $DEPLOYMENT_NAME-ui.json
sed -i "" -e "s/DEPLOYMENTNAME/$DEPLOYMENT_NAME/g" $DEPLOYMENT_NAME-ui.json
sed -i "" -e "s/MANTLDOMAIN/$MANTL_DOMAIN/g" $DEPLOYMENT_NAME-ui.json
sed -i "" -e "s/TAG/$TAG/g" $DEPLOYMENT_NAME-ui.json


echo Deploying UI Service
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @$DEPLOYMENT_NAME-ui.json \
| python -m json.tool
echo
echo "***************************************************"
echo

echo Deployed
echo " "
echo "Wait 5-10 minutes for the service to deploy "
echo "and then open the following page in your browser to view the application."
echo " "
echo "    http://$DEPLOYMENT_NAME-ui.$MANTL_DOMAIN "
echo " "
echo " "

