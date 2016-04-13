
# MyHero Microservice Demo Application

This is provided as a very simple application that can be used to demonstrate
[Cisco Mantl](http://mantl.io).

The application provides a simple interface for gathering and reporting votes about the best movie superheros.

The application is built in a microservice style wrapping each service in a docker container
 that can be deployed and run in Mantl.  In its initial form the applicaiton has three services.

1.  myhero/data - This service stores all the data about candidates and votes cast.
2.  myhero/app - This service provides the basic logic layer for accessing and recording votes.
3.  myhero/web - This is the main user interface for casting votes.

## Prerequisites

In order to leverage this demonstration, you will need to have a Mantl cluster up and functional already.  For help with this visit the Docs site available at [http://mantl.io](http://mantl.io).  You will need to have the address for the control nodes and a username and password for an active account.

## Setup

Run `source myhero_setup` to enter and record the address, application domain, username, and password for your Mantl instance as non-persistent Environment Variables.  This means you will need to run this command everytime you open an new terminal session.

## Install

Run `./myhero-install.sh` to deploy all three services (data, app, web) to your Mantl cluster.

After running the install it will take a 2-5 minutes for all three services to fully deploy and become "healthy".  You can monitor this in the Marathon Web GUI.

You should be able to reach the web interface for the application at `http://myhero-web.YOUR-DOMAIN` where `YOUR-DOMAIN` refers to the wildcard domain configured for Traefik.

## Uninstallation

Run `./myhero-uninstall.sh` to remove all three services from Marathon.

## Basic Scaling Demo

A script is included to show how you can easily scale services with Mantl.

Run `./myhero-scaleweb.sh` to have options to change the number of web and app instances deployed.  You can scale up or down with this script.

## Advanced Demos

### Installation
If you would rather demo deploying each service independently you can use these sample curl commands.  These commands assume that you've run `source myhero_setup` to store environment variables for key details.

* Deploy the data service
  * `curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps -H "Content-type: application/json" -d @myhero-data.json| python -m json.tool`
* Deploy the app service
  * `curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps -H "Content-type: application/json" -d @myhero-app.json | python -m json.tool`
  * `curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/app?force=true -H "Content-type: application/json" -d "{\"env\": {\"myhero_data_server\": \"http://myhero-data.$MANTL_DOMAIN\"}}" | python -m json.tool`
* Deploy the web service
  * `curl -k -X POST -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps -H "Content-type: application/json" -d @myhero-web.json | python -m json.tool`
  * `curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/web?force=true -H "Content-type: application/json" -d "{\"env\": {\"myhero_app_server\": \"http://myhero-app.$MANTL_DOMAIN\"}}" | python -m json.tool`

### Scaling a Service
* To scale up the web service
  * `curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/web -H "Content-type: application/json" -d '{"instances":5}' | python -m json.tool`

### Getting Details on a Service
* To get the details on one of the services
  * `curl -k -X GET -u $MANTL_USER:$MANTL_PASSWORD https://$MANTL_CONTROL:8080/v2/apps/myhero/web -H "Content-type: application/json" | python -m json.tool`

### Interfacing with the App Tier API

A strength of Modern Applciations are that you can interact with any of the services directly through APIs if the native interface isn't desireable.  Here are some examples interacting with the app service directly.

* View the list of potential Superheros to vote for.
  * `curl http://myhero-app.$MANTL_DOMAIN/hero_list`
* View the current standings.
  * `curl http://myhero-app.$MANTL_DOMAIN/results`
* Place a vote for a hero
  * `curl http://myhero-app.$MANTL_DOMAIN/vote/Batman`