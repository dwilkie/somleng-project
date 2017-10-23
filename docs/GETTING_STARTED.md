# Getting Started

This guide is intended to give you instant gratification.

## Prerequisites

Install [Docker](https://docs.docker.com/engine/installation), [docker-compose](https://docs.docker.com/compose/install/) and [git (optional but highly recommended)](https://git-scm.com/downloads)

## Clone the repository using git

Or download `docker-compose.yml` manually [here](https://raw.githubusercontent.com/somleng/somleng-project/master/docker-compose.yml)

```
$ git clone https://github.com/somleng/somleng-project --depth 1 && cd somleng-project
```

## Pull the latest images

```
$ docker-compose pull
```

## Setup and seed Somleng's REST API

```
$ docker-compose run --rm -e INCOMING_PHONE_NUMBER="{\"phone_number\":\"1234\",\"voice_url\":\"http://demo.twilio.com/docs/voice.xml\"}" twilreapi /bin/bash -c './bin/rails db:setup'
```

## Start Somleng's services

Note the following command will start all Somleng's services including a docker image with [Linphone](http://www.linphone.org/) (a softphone CLI). If you want to use your own softphone running on your host uncomment the lines in [docker-compose.yml](https://github.com/somleng/somleng-project/blob/master/docker-compose.yml)

```
$ docker-compose up
```

## Make a call

In another terminal...

### Get the Account SID and Auth Token

```
$ IFS=: read ACCOUNT_SID AUTH_TOKEN <<< $(docker-compose run --rm -e FORMAT=basic_auth twilreapi /bin/bash -c './bin/rails db:seed') && echo "Account SID: $ACCOUNT_SID" && echo "Auth Token: $AUTH_TOKEN"
```

### Initiate a call with CURL

```
$ RESPONSE=$(docker-compose run --rm -e "ACCOUNT_SID=$ACCOUNT_SID" -e "AUTH_TOKEN=$AUTH_TOKEN" curl /bin/sh -c 'curl "http://twilreapi:3000/api/2010-04-01/Accounts/$ACCOUNT_SID/Calls.json" --data-urlencode "Method=GET" --data-urlencode "Url=http://demo.twilio.com/docs/voice.xml" --data-urlencode "To=+85510202101" --data-urlencode "From=1234" -u "$ACCOUNT_SID:$AUTH_TOKEN"') && echo $RESPONSE
```

### Answer the call with linphone

```
$ docker-compose exec linphone /bin/bash -c 'linphonecsh generic answer'
```

### Hangup the call with linphone

```
$ docker-compose exec linphone /bin/bash -c 'linphonecsh generic terminate'
```

## Get the call from the REST API

```
$ CALL_SID=$(docker-compose run --rm -e "JSON=$RESPONSE" curl /bin/sh -c 'echo $JSON | jq -j ".sid"') && echo $CALL_SID
$ docker-compose run -e "ACCOUNT_SID=$ACCOUNT_SID" -e "AUTH_TOKEN=$AUTH_TOKEN" -e "CALL_SID=$CALL_SID" curl /bin/sh -c 'curl "http://twilreapi:3000/api/2010-04-01/Accounts/$ACCOUNT_SID/Calls/$CALL_SID.json" -u "$ACCOUNT_SID:$AUTH_TOKEN"'
```

## Make an inbound call with linphone

```
$ docker-compose exec linphone /bin/bash -c 'linphonecsh generic "call 1234@freeswitch"'
```

Note: You can hangup the call using:

```
$ docker-compose exec linphone /bin/bash -c 'linphonecsh generic terminate'
```
