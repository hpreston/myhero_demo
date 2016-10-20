
# MyHero Microservice Demo Application

![MyHero Demo Application](diagrams/myhero-demo-i2.png)

## Links

* [Setup](#setup)
* [Install](#install)
* [Basic Scaling Demo](#basic-scaling-demo)
* [Advanced Demos](#advanced-demos)
* [Code and Containers](#myhero-application-code-and-containers)
* [Uninstallation](#uninstallation)

# Background

This is provided as a very simple application that can be used to demonstrate the concepts behind a cloud native application that can be deployed onto [Cisco Mantl](http://mantl.io).  Though designed with Mantl in mind, there is nothing specific to the application and underlying services that require Mantl to function.  Any platform for deploying container based microservices should be acceptable.

[Cisco Devnet](http://developer.cisco.com) provides a Mantl Sandbox for anyone to use for testing, learning and developing that can be easily leveraged with the MyHero application.  Details on Mantl can be found at [Mantl @ DevNet](https://developer.cisco.com/site/mantl/).  And you can access the Sandbox details at [Mantl Sandbox](https://devnetsandbox.cisco.com/RM/Diagram/Index/94487c25-2b16-4204-b45f-09a5939b0f57?diagramType=Topology). 

The application provides a simple interface for gathering and reporting votes about the best movie superheros.

The application is built in a microservice style wrapping each service in a docker container
 that can be deployed and run in Mantl.  In its initial form the applicaiton has three services.

1. [myhero/data](https://github.com/hpreston/myhero_data) - This service stores all the data about candidates and votes cast.
2. [myhero/app](https://github.com/hpreston/myhero_app) - This service provides the basic logic layer for accessing and recording votes.
3. [myhero/web](https://github.com/hpreston/myhero_web) - This is the main user interface for casting votes.

There is an optional deployment mode where votes are processed through an MQTT Server by being published by the myhero/app service, and processed by myhero/ernst service that subscribes to the queue.
In this mode, these additional services are deployed.

4. myhero/mosca - MQTT Server based on [Mosca](https://hub.docker.com/r/matteocollina/mosca/)
5. [myhero/ernst](https://github.com/hpreston/myhero_ernst) - Vote processing services

![MyHero Queueing Arch](diagrams/myhero-queue-arch.png)

All of the demo details here make use of the Mantl or Marathon APIs to build and manage applciations.  If you prefer to use the different GUIs to execute the demos, you can use the JSON files to find the details needed to configure manually.

# Optional Additional Services
A great application today allows users to interact with the service in whichever way the end user prefers.  No longer should we be satisfied with simply a web interface on a desktop or laptop.  Users are looking for options such as:
* Mobile - smartphones and tablets
* Wearables - smartwatches
* Realtime Chat
* Voice Interaction
* Gesture Based
* and more

So with this in mind, MyHero offers some optional additional services for a fuller experienece.  Check back often as the list of optional services will grow overtime.

## Cisco Spark Bot
Realtime Chat is becoming very popular with consumer as well as professional world.  Cisco Spark is an enterprise collaboration platform offering text, voice, and video options for group and one on one communciations.  MyHero now can leverage Cisco Spark to allow users to Chat with a Spark Bot to learn about the voting service, find out current results, and cast votes.

![MyHero SparkBot](diagrams/sparkbot-i1.png)

To setup the Spark Bot visit [Spark Bot Setup](./spark_setup.md)

**NOTE: To leverage the Spark Bot Service, your Mantl Cluster MUST be configured for deployed applications to be accessible from the public Internet.  This is because it relies on the Spark Cloud to be able to send a WebHook to the myhero_spark application you run in Mantl***

## Cisco Tropo Service
Mobile phones are everywhere, and SMS/TXT continues to be a method for interacting with services.  Cisco Tropo is a SaaS solution that provides Voice and SMS services that can be integrated to any applciation through a very easy to use API.  MyHero has an optional Tropo service that allows users to send SMS messages to the MyHero applciation to learn abou the voting service, find out current results, and cast votes.

![MyHero Tropo Service](diagrams/troposervice-i1.png)

To setup the Tropo Service visit [Tropo Service Setup](./tropo_setup.md)

**NOTE: To leverage the Tropo Service, your Mantl Cluster MUST be configured for deployed applications to be accessible from the public Internet.  This is because it relies on the Tropo Cloud to be able to send a REST call to the myhero_tropo application you run in Mantl***

# Prerequisites

In order to leverage this demonstration, you will need to have a Mantl cluster up and functional already.  For help with this visit the Docs site available at [http://mantl.io](http://mantl.io).  You will need to have the address for the control nodes and a username and password for an active account.

# Setup

Run `source myhero_setup` to enter and record the deployment name, address, application domain, username, and password for your Mantl instance as non-persistent Environment Variables.  This means you will need to run this command everytime you open an new terminal session.

# Application Deployment

![Full MyHero Application Architecture](diagrams/myhero-arch-full-v3.png)

## Install

Run `./myhero-install.sh` to deploy the default configuration to your Mantl Cluster.  This includes: 

* myhero_data 
* myhero_app
* myhero_ernst
* myhero_queue
* myhero_ui

After running the install it will take a 2-5 minutes for all three services to fully deploy and become "healthy".  You can monitor this in the Marathon Web GUI.

You should be able to reach the web interface for the application at `http://DEPLOYMENTNAME-ui.YOUR-DOMAIN` where `DEPLOYMENTNAME` refers to the deployment name provided at setup and `YOUR-DOMAIN` refers to the application domain configured for Traefik.

# Basic Scaling Demo

A script is included to show how you can easily scale services with Mantl.

Run `./myhero-scale-demo.sh` to have options to change the number of ui and app instances deployed.  You can scale up or down with this script.

# Advanced Demos

## Scaling a Service
* To scale up the ui service

  ```
  curl -k -X PUT -u $MANTL_USER:$MANTL_PASSWORD \
     https://$MANTL_CONTROL:8080/v2/apps/$DEPLOYMENT_NAME/ui \
     -H "Content-type: application/json" \
     -d '{"instances":5}' 
  ```

## Getting Details on a Service
* To get the details on one of the services

  ```
  curl -k -X GET -u $MANTL_USER:$MANTL_PASSWORD \
     https://$MANTL_CONTROL:8080/v2/apps/$DEPLOYMENTNAME/ui \
     -H "Content-type: application/json" 
  ```

## Interfacing with the App Tier API

A strength of Modern Applications are that you can interact with any of the services directly through APIs if the native interface isn't desireable.  Here are some examples interacting with the app service directly.

* View the list of potential Superheros to vote for.
  
  ```
  curl -H "key: SecureApp" http://$DEPLOYMENT_NAME-app.$MANTL_DOMAIN/options
  ```

* View the current standings.
  
  ```
  curl -H "key: SecureApp" http://$DEPLOYMENT_NAME-app.$MANTL_DOMAIN/v2/results
  ```
  
* Place a vote for a hero

  ```
  curl -H "key: SecureApp" -X POST http://$DEPLOYMENT_NAME-app.$MANTL_DOMAIN/vote/Batman
  ```

# MyHero Application Code and Containers

## GitHub Repos

* Data - [hpreston/myhero_data](https://github.com/hpreston/myhero_data)
* App - [hpreston/myhero_app](https://github.com/hpreston/myhero_app)
* UI - [hpreston/myhero_ui](https://github.com/hpreston/myhero_ui)
* Ernst - [hpreston/myhero_ernst](https://github.com/hpreston/myhero_ernst)
  * Optional Service used along with an MQTT server when App is in "queue" mode
* Spark Bot - [hpreston/myhero_spark](https://github.com/hpreston/myhero_spark)
  * Optional Service that allows voting through IM/Chat with a Cisco Spark Bot
* Tropo App - [hpreston/myhero_tropo](https://github.com/hpreston/myhero_tropo)
  * Optional Service that allows voting through TXT/SMS messaging
* Web - [hpreston/myhero_web](https://github.com/hpreston/myhero_web)
	* _Original Web interface for MyHero.  Replaced by UI_


## Docker Containers 

* Data - [hpreston/myhero_data](https://hub.docker.com/r/hpreston/myhero_data)
* App - [hpreston/myhero_app](https://hub.docker.com/r/hpreston/myhero_app)
* UI - [hpreston/myhero_ui](https://hub.docker.com/r/hpreston/)
* Ernst - [hpreston/myhero_ernst](https://hub.docker.com/r/hpreston/myhero_ernst)
  * Optional Service used along with an MQTT server when App is in "queue" mode
* Spark Bot - [hpreston/myhero_spark](https://hub.docker.com/r/hpreston/myhero_spark)
  * Optional Service that allows voting through IM/Chat with a Cisco Spark Bot
* Tropo App - [hpreston/myhero_tropo](https://hub.docker.com/r/hpreston/myhero_tropo)
  * Optional Service that allows voting through TXT/SMS messaging
* Web - [hpreston/myhero_web](https://hub.docker.com/r/hpreston/myhero_web)
	* _Original Web interface for MyHero.  Replaced by UI_
myhero_ui)

# Other Mantl Demo Ideas

There are many other ideas for demo's to run with Mantl.  Several of these leverage example content delivered with the Mantl code in the examples/ directory.  Others deploy Mesos frameworks using the Mantl API.  Review these directories as well as the documentation at [docs.mantl.io](http://docs.mantl.io).

# Uninstallation

Run `./myhero-uninstall.sh` to remove all services from Marathon.
