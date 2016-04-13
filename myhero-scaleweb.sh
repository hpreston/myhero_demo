!# /bin/bash

echo "How many web instances do you want?"
read web_count

echo "How many app instances do you want?"
read app_count

echo "You want $web_count web instances and $app_count app instances."

echo "Scaling Web Service."
curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/web \
-H "Content-type: application/json" \
-d "{\"instances\": $web_count}"
echo
echo "Done"
echo

echo "Scaling App Service."
curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/app \
-H "Content-type: application/json" \
-d "{\"instances\": $app_count}"
echo
echo "Done"
echo
