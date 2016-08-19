#! /bin/bash

[ -z "$MANTL_CONTROL" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_USER" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_PASSWORD" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_DOMAIN" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$DEPLOYMENT_NAME" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

MINIO_URL="http://$DEPLOYMENT_NAME-minio.$MANTL_DOMAIN"
MINIO_ACCESS_ID="myheroobjectstorage"
MINIO_SECRET="objectstoragesecret"

echo " "
echo "***************************************************"
echo Checking if Minio has already been deployed with deployment name \"$DEPLOYMENT_NAME\"
python mantl_utils.py applicationexists $DEPLOYMENT_NAME/minio
if [ $? -eq 1 ]
then
    echo "    Deployment name available, continuing."
else
    echo "    Deployment name already used."
    echo "    Rerun 'source myhero_setup' and choose a new deployment name."
    exit 1
fi

# Create Copy of JSON Definitions for Deployment
echo "Creating Service Definifitions "

cp sample-myhero-minio.json $DEPLOYMENT_NAME-minio.json
sed -i "" -e "s/DEPLOYMENTNAME/$DEPLOYMENT_NAME/g" $DEPLOYMENT_NAME-minio.json
sed -i "" -e "s/MANTLDOMAIN/$MANTL_DOMAIN/g" $DEPLOYMENT_NAME-minio.json
sed -i "" -e "s/TAG/$TAG/g" $DEPLOYMENT_NAME-minio.json
sed -i "" -e "s/MINIOACCESSID/$MINIO_ACCESS_ID/g" $DEPLOYMENT_NAME-minio.json
sed -i "" -e "s/MINIOSECRET/$MINIO_SECRET/g" $DEPLOYMENT_NAME-minio.json
sed -i "" -e "s#MINIOURL#$MINIO_URL#g" $DEPLOYMENT_NAME-minio.json


cp sample-myhero-objsetup.json $DEPLOYMENT_NAME-objsetup.json
sed -i "" -e "s/DEPLOYMENTNAME/$DEPLOYMENT_NAME/g" $DEPLOYMENT_NAME-objsetup.json
sed -i "" -e "s/MANTLDOMAIN/$MANTL_DOMAIN/g" $DEPLOYMENT_NAME-objsetup.json
sed -i "" -e "s/TAG/$TAG/g" $DEPLOYMENT_NAME-objsetup.json
sed -i "" -e "s/MINIOACCESSID/$MINIO_ACCESS_ID/g" $DEPLOYMENT_NAME-objsetup.json
sed -i "" -e "s/MINIOSECRET/$MINIO_SECRET/g" $DEPLOYMENT_NAME-objsetup.json
sed -i "" -e "s#MINIOURL#$MINIO_URL#g" $DEPLOYMENT_NAME-objsetup.json


echo Deploying Minio Service
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @$DEPLOYMENT_NAME-minio.json \
| python -m json.tool
echo
echo "***************************************************"
echo


##############################################################
# 1) check if minio is up

echo "Checking if Minio is up"
HTTP_STATUS=$(curl -sL -w "%{http_code}" "$MINIO_URL" -o /dev/null)
while [ $HTTP_STATUS -ne 403 ]
do
    HTTP_STATUS=$(curl -sL -w "%{http_code}" "$MINIO_URL" -o /dev/null)
    echo "Minio not up yet, checking again in 30 seconds. "
    sleep 30
done
echo
echo "Minio is up.  Beginning Configuraiton"
echo


echo Deploying Object Storage Configuration Service
curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps \
-H "Content-type: application/json" \
-d @$DEPLOYMENT_NAME-objsetup.json \
| python -m json.tool
echo
echo "***************************************************"
echo


# Create bucket for images
# Set policy to download
# Copy files to bucket

echo Deployed
echo " "
echo "Wait 5-10 minutes for the service to deploy "
echo "and then open the following page in your browser to view the application."
echo " "
echo "    http://$DEPLOYMENT_NAME-minio.$MANTL_DOMAIN "
echo " "
echo " "

