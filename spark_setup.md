# MyHero Demo Spark Bot Setup

[Back to MyHero Demo Setup](./README.md)

![MyHero SparkBot](diagrams/sparkbot-i1.png)


## Prerequisites

In order to leverage this demonstration, should have already installed the base MyHero Demo app and have the Data and App Services up and Operational.

**NOTE: To leverage the Spark Bot Service, your Mantl Cluster MUST be configured for deployed applications to be accessible from the public Internet.  This is because it relies on the Spark Cloud to be able to send a WebHook to the myhero_spark application you run in Mantl***

## Spark Developer Account Requirement

In order to use this service, you will need a Cisco Spark Account to use for the bot. The bot is built for ease of use, meaning any message to the account used to create the Bot will be acted on and replied to. This means you'll need to create a new Spark account for the demo.

Creating an account is free and only requires a working email account (each Spark Account needs a unique email address).  Visit [http://www.ciscospark.com](http://www.ciscospark.com) to signup for an account.

Developer access to Spark is also free and information is available at [http://developer.ciscospark.com](http://developer.ciscospark.com).

In order to access the APIs of Spark, this bot needs the Developer Token for your account.  To find it:

* Go to [http://developer.ciscospark.com](http://developer.ciscospark.com) and login with the credentials for your account.
* In the upper right corner click on your picture and click `Copy` to copy your Access Token to your clipboard
* Make a note of this someplace for when you need it later in the setup
  * **If you save this in a file, such as in the `Vagrantfile` you create later, be sure not to commit this file.  Otherwise your credentials will be availabe to anyone who might look at your code later on GitHub.**


## Setup

* Run `source myhero_setup` to enter and record the address, application domain, username, and password for your Mantl instance as non-persistent Environment Variables.  This means you will need to run this command everytime you open an new terminal session.
  * If you've already run this to install the MyHero Demo web, app, and data services, you do NOT need to run again.
* Run `source spark_setup` to enter your Spark Email Account and Token that will be saved as non-persistent Environment Variables.  This means you will need to run this command everytime you open a new terminal instance.


## Install

* Run `./spark-install.sh` to deploy all the "spark" service into your running "myhero" application in your Mantl cluster.

* After running the install it will take a 2-5 minutes for the service to fully deploy and become "healthy".  You can monitor this in the Marathon Web GUI.


## Interacting with the Spark Bot
The Spark Bot is a very simple interface that is designed to make it intuitive to use.  Simply send any message to the Spark Bot Email Address to have the bot reply back with some instructions on how to access the features.

The bot is deisgned to look for commands to act on, and provide the basic help message for anything else.  The commands are:

* /options
  * return a list of the current available options to vote on
* /results
  * list the current status of voting results
* /vote {{ option }} 
  * Place a vote for the 'option'
* /help 
  * Provide a help message

## REST APIs

### /hello/:email 

There is an API call that can be leveraged to have the Spark Bot initiate a chat session with a user.  This API responds to GET requests and then will send a Spark message to the email provided.  

Example usage

```
curl http://myhero-spark.domain.local/hello/user@email.com 
```

## Uninstallation

The Spark Bot is uninstalled with the same script used to uninstall the rest of the MyHero application.  

Run `./myhero-uninstall.sh` to remove all services from Marathon.  

__At this time, no cleanup on rooms, webhooks, or messages in Spark is done__.
