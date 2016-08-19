#!/usr/bin/env bash

echo
echo "Thank you for using the MyHero Demo Application."
echo "This script will allow you to scale the UI and App Services. "
echo
echo "Press Enter to continue..."
read confirm
echo

[ -z "$MANTL_CONTROL" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_USER" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_PASSWORD" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$MANTL_DOMAIN" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;
[ -z "$DEPLOYMENT_NAME" ] && echo "Please run 'source myhero_setup' to set Environment Variables" && exit 1;

echo "How many UI instances do you want?"
read ui_count

echo "How many App instances do you want?"
read app_count

echo "You want $ui_count UI instances and $app_count App instances."

echo "Scaling UI Service."
curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/$DEPLOYMENT_NAME/ui \
-H "Content-type: application/json" \
-d "{\"instances\": $ui_count}"
echo
echo "Done"
echo

echo "Scaling App Service."
curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/$DEPLOYMENT_NAME/app \
-H "Content-type: application/json" \
-d "{\"instances\": $app_count}"
echo
echo "Done"
echo

