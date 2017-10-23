# Case Study - Somleng, UNICEF Somalia, Africa's Voices Foundation (AVF)

## Location

[Somalia](https://en.wikipedia.org/wiki/Somalia)

## Preface

This is a technical document about the Somleng deployment for [Africa's Voices Foundation (AVF)](http://www.africasvoices.org/) in conjunction with [UNICEF Somalia](https://www.unicef.org/somalia/). It assumes that the reader has some knowledge about [Somleng](https://github.com/somleng/somleng-project/blob/master/docs/what_is_somleng.md) and [RapidPro](https://community.rapidpro.io/). The document focuses on technology related aspects of the project. This document is Open Source. [Pull requests](https://github.com/somleng/somleng-project/pulls) are welcome. Previous diffs and versions are available [here](https://github.com/somleng/somleng-project/commits/master/docs/case_study_africas_voices.md).

## Introduction

From: [http://rtd.somleng.org/](http://rtd.somleng.org/)

> Returnee households from Dadaab refugee camp in Kenya and vulnerable households in Bay and Bakool received emergency unconditional cash-based transfer assistance package to help them meet their needs during the current drought period. Voice-based messaging is used to share information on the program and inform them of feedback loops.

## Technology

### Stack

1. [Somleng Simple Call Flow Manager (Somleng SCFM)](https://github.com/somleng/somleng-scfm) controls scheduling, queuing, retrying and analysis of outbound calls through [Somleng's REST API](https://github.com/somleng/twilreapi). Somleng SCFM also connects to [RapidPro](https://community.rapidpro.io/) to trigger outbound SMS flows.
2. [RapidPro](https://community.rapidpro.io/) controls SMS flows and handles inbound phone calls received from Somleng.
3. [Somleng](https://github.com/somleng/freeswitch-config) is connected to Shaqodoon which acts as an aggregator for the Mobile Network Operators (MNOs) in Somalia.
4. The MNOs deliver and receive calls through local mobile networks.

### Hosting

A new instance of Somleng was deployed to [Amazon Web Services (AWS)](https://aws.amazon.com/) for this project, with the intention of reusing the instance later for other projects.

#### AWS Region

Initially Somleng was deployed to AWS (Mumbai, India) because it's the [closest available region to Somalia](https://aws.amazon.com/about-aws/global-infrastructure/). However it was discovered during the deployment that AWS (Mumbai, India) lacks support for some critical infrastructure that Somleng requires for deployment. Specifically the missing infrastructure is support for [Elastic Beanstalk Multi-Container Docker environments](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_ecs.html) (this still remains undocumented on AWS). After this was discovered Somleng was redeployed to AWS Singapore.

The average [round trip (ping) time](https://en.wikipedia.org/wiki/Ping_(networking_utility)) from [Somleng's FreeSWITCH instance](https://github.com/somleng/freeswitch-config) hosted on AWS in Singapore to Shaqodoon's server hosted at [Telesom Tower, Hargeisa, Somaliland](https://www.google.com.kh/maps/place/Telesom+Tower/@9.5589495,44.0667021,20z/data=!4m12!1m6!3m5!1s0x1628bf9a0f0071e9:0x915dbb06d93f5bc!2sTelesom+Tower!8m2!3d9.5590572!4d44.067058!3m4!1s0x1628bf9a0f0071e9:0x915dbb06d93f5bc!8m2!3d9.5590572!4d44.067058?hl=en) is `~450ms`. Initially it was thought that this latency may cause an issue with quality. however after testing we discovered that because the interaction with the callee is non-conversational in nature (a conversation example would be two people talking on the phone together), latency was not an issue.

#### Domain

For this project the domain `unicef.io` was purchased with the intention of reusing the domain for additional UNICEF technology related projects. The domain is managed by [AWS Route 53](https://aws.amazon.com/route53/). [Somleng's REST API](https://github.com/somleng/twilreapi) is hosted at [somleng.unicef.io](somleng.unicef.io/).

### Shaqadoon

Somleng is connected to [Shaqodoon](http://shaqodoon.org/technology/) which acts as an aggregator for the multiple Mobile Network Operators (MNOs) in Somalia. Shaqodoon provides a [SIP](https://en.wikipedia.org/wiki/Session_Initiation_Protocol) endpoint to an [Asterisk](http://www.asterisk.org/) server. Shaqodoon provides one [E1 line](https://en.wikipedia.org/wiki/E-carrier) to each MNO. Each E1 line can support up to 32 simultaneous calls. Shaqodoon aggregates the the following MNOs:

1. [Telesom](https://en.wikipedia.org/wiki/Telesom)
2. [Golis](https://en.wikipedia.org/wiki/Golis_Telecom_Somalia)
3. [NationLink](https://en.wikipedia.org/wiki/NationLink_Telecom)
4. [Somtel](https://en.wikipedia.org/wiki/Somtel)
5. [Hormuud](https://en.wikipedia.org/wiki/Hormuud_Telecom)

### Issues and Feature Enhancements

#### Call Throttling

Since Shaqodoon (the aggregator) only provides one [E1 line](https://en.wikipedia.org/wiki/E-carrier) to each MNO (with each line supporting 32 calls) the customer, Africa's Voices Foundation (AVF) quickly ran into issues relating to call throttling when triggering outbound calls through RapidPro.

If a call is triggered when an E1 line is full, [Somleng's FreeSWITCH instance](https://github.com/somleng/freeswitch-config) receives a `503` [SIP Response Code](https://en.wikipedia.org/wiki/List_of_SIP_response_codes#5xx.E2.80.94Server_Failure_Responses) from Shaqodoon. According to the [Twilio standard](https://www.twilio.com/docs/api/voice/call#call-status-values) Somleng reports this to the client (in this case RapidPro) as a `failed` call. It's then up to the client (RapidPro) to retry the call through Somleng (or not) according the the logic of the application.

Since [RapidPro does not support retrying calls](https://github.com/rapidpro/rapidpro/issues/599), it was decided to bypass RapidPro for triggering outbound calls. Instead of using triggering outbound calls through RapidPro, AVF wrote their own retry logic which connects to [Somleng's REST API](https://github.com/somleng/twilreapi) directly.

AVF ran into some technical issues with their retry logic which resulted in Somleng developing a new new product called [Somleng Simple Call Flow Manager (Somleng SCFM)](https://github.com/somleng/somleng-scfm) which is specifically designed for queuing, retrying, scheduling and analysis of calls. AVF now uses [Somleng SCFM](https://github.com/somleng/somleng-scfm) to automatically retry failed calls.

#### Call Recording

At the beginning of the project the ability to record calls was not yet supported by Somleng. When it became apparent that this was a required functionality we decided to add this feature to Somleng. The addition of this feature required a significant amount of work. Below is a summary of the work.

##### Technical Flow

The following sequence of events describes at a high level what was implmented in Somleng to support recording calls.

1. Outbound/Inbound Call is initiated/received through/by Somleng
2. [Adhearsion-Twilio](https://github.com/somleng/adhearsion-twilio) requests [TwiML](https://www.twilio.com/docs/api/twiml) from the client application.
3. TwiML contains the `<Record>` verb.
4. [Adhearsion-Twilio](https://github.com/somleng/adhearsion-twilio) sends a `recording_started` event to [Somleng's REST API](https://github.com/somleng/twilreapi).
5. Recording starts.
6. Recording finishes.
7. [Adhearsion-Twilio](https://github.com/somleng/adhearsion-twilio) sends a `recording_finished` event to [Somleng's REST API](https://github.com/somleng/twilreapi).
8. Recording is uploaded to [S3](https://aws.amazon.com/s3/).
9. [AWS Simple Notification Service (SNS)](https://aws.amazon.com/sns/) sends a notification to [Somleng's REST API](https://github.com/somleng/twilreapi) that a new recording has been uploaded to [S3](https://aws.amazon.com/s3/).
10. A new Recording is created in the database which links to the Phone Call and the recording.
11. The recording is downloaded, processed then re-uploaded to [S3](https://aws.amazon.com/s3/).
12. The [recordingStatusCallback](https://www.twilio.com/docs/api/twiml/record#attributes-recording-status-callback) is sent to the client application which indicates the recording is ready.

##### Phone Call Events

As shown in the [technical flow](#technical-flow) above, in order for the [Record verb](https://www.twilio.com/docs/api/twiml/record) to be added to [Adhearsion-Twilio](https://github.com/somleng/adhearsion-twilio) we had to first [add support for Phone Call Events](https://github.com/somleng/twilreapi/issues/20) in [Somleng's REST API](https://github.com/somleng/twilreapi).

The Phone Call Events table tracks individual events on a Phone Call. For Recordings we need to keep track of the [TwiML attributes](https://www.twilio.com/docs/api/twiml/record#attributes) that the client puts in the [Record verb](https://www.twilio.com/docs/api/twiml/record). To complicate matters, each phone call may have multiple recordings, triggered by multiple [TwiML Record verbs](https://www.twilio.com/docs/api/twiml/record) and multiple recordings may be happening simultaneously across different phone calls.

A `recording_started` event notifies [Somleng's REST API](https://github.com/somleng/twilreapi) that a recording has been started for a particular phone call. The event includes the [TwiML attributes](https://www.twilio.com/docs/api/twiml/record#attributes) for the Recording which will be used later in the flow. [(See also step #4 in technical flow)](#technical-flow)

A `recording_finished` event notifies [Somleng's REST API](https://github.com/somleng/twilreapi) that a recording has been finished for a particular phone call. The event includes the [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) of the recording file which will be used later in the flow. [(See also step #7 in technical flow)](#technical-flow)

##### Implementation of the Record Verb in Adhearsion-Twilio

The following describes [steps #3-#7 in the technical flow](#technical-flow).

[Adhearsion-Twilio](https://github.com/somleng/adhearsion-twilio) (written by Somleng) is an [Adhearsion Plugin](http://adhearsion.com/docs/plugins) which translates [Twilio Markup Language (TwiML)](https://www.twilio.com/docs/api/twiml) into Adhearsion commands which get executed on [FreeSWITCH](https://github.com/somleng/freeswitch-config).

[Adhearsion-Twilio](https://github.com/somleng/adhearsion-twilio) is used in [Somleng's Adhearsion Application](https://github.com/somleng/somleng) which sits between [Somleng's REST API](https://github.com/somleng/twilreapi) and [FreeSWITCH](https://github.com/somleng/freeswitch-config).

The [<Record/> verb](https://www.twilio.com/docs/api/twiml/record) was [implemented](https://github.com/somleng/adhearsion-twilio/issues/19) in order to initiate recordings on [FreeSWITCH](https://github.com/somleng/freeswitch-config).

##### Getting the Recording from Docker to S3

The following describes [step #8 in the technical flow](#technical-flow).

The raw recording is initially saved to file inside [FreeSWITCH's](https://github.com/somleng/freeswitch-config) docker container. Although the recording directory can be specified in the [FreeSWITCH configuration](https://github.com/somleng/freeswitch-config) it does not allow for uploading the Recording directly to [S3](https://aws.amazon.com/s3/).

The [implementation](https://github.com/somleng/freeswitch-config/issues/12) uses [cron](https://en.wikipedia.org/wiki/Cron) which runs in a separate process to mount the FreeSWITCH docker container's recording directory upload new recordings to [S3](https://aws.amazon.com/s3/).

##### Linking the Recording to the Phone Call

The following describes [steps #9-#10 in the technical flow](#technical-flow).

Once the recording has been uploaded to [S3](https://aws.amazon.com/s3/) it needs to be linked to the phone call record in the database so it can be downloaded by the client application through [Somleng's REST API](https://github.com/somleng/twilreapi).

The [implementation](https://github.com/somleng/twilreapi/issues/27) uses [AWS's Simple Notification Service (SNS)](https://aws.amazon.com/sns/) which sends a notification to [Somleng's REST API](https://github.com/somleng/twilreapi) that a new recording was uploaded to [S3](https://aws.amazon.com/s3/).

Somleng then finds the originating the Phone Call by matching the [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) in the filename of the uploaded recording with what was saved from the `recording_finished` event (see step #7 in the [technical flow](#technical-flow)).

##### Processing the Recording

The following describes [step #11 in the technical flow](#technical-flow).

After the recording has been linked to the originating phone call, it needs to be processed according to the attributes supplied in the [TwiML attributes](https://www.twilio.com/docs/api/twiml/record#attributes) by the client application. These attributes were received by Somleng's REST API in step #4 of the [technical flow](#technical-flow). The recording is downloaded from [S3](https://aws.amazon.com/s3/), processed then re-uploaded.

##### Notifying the client that Recording is ready for download

The following describes [step #12 in the technical flow](#technical-flow).

The final step in the recording flow is to notify the client application that the recording is ready for download. This is specified in the [TwiML specification](https://www.twilio.com/docs/api/twiml/record#attributes-recording-status-callback) and can be enabled by the client application by specifying the `recordingStatusCallback` attribute.

##### RapidPro issues

RapidPro does not follow the [Twilio Standard](https://www.twilio.com/docs/api/twiml/record) when downloading recordings. The [issue](https://github.com/rapidpro/rapidpro/issues/604) has been discussed on RapidPro.

AVF uses [Somleng SCFM](https://github.com/somleng/somleng-scfm) which downloads the recordings from [Somleng's REST API](https://github.com/somleng/twilreapi) bypassing RapidPro.

#### 603 Issue

Shaqodoon uses the status [SIP Status Code](https://en.wikipedia.org/wiki/List_of_SIP_response_codes#6xx.E2.80.94Global_Failure_Responses) `603` to indicate that the call was not answered. Previously this status code was not recognized by Somleng which returned a `failed` call status as per the [Twilio spec](https://www.twilio.com/docs/api/voice/call#call-status-values). The `603` status code was consequently added as part of the [Phone Call Events implementation](https://github.com/somleng/twilreapi/issues/20).

#### DTMF Issues

There were also some issues relating to the recognition of [DTMF Tones](https://en.wikipedia.org/wiki/Dual-tone_multi-frequency_signaling). As part of the debugging process, a configuration setting was [added](https://github.com/somleng/freeswitch-config/commit/f7da1a3e6880e1dee70dc607c85ade0e0f197d83) to FreeSWITCH to optionally allow detection of Inband DTMF tones.

Additional configuration changes were made on Shaqodoon's side. Successful tests were conducted and recorded using [Wireshark](https://www.wireshark.org/).

#### CID Issues

Originally the [Caller ID (CID)](https://en.wikipedia.org/wiki/Caller_ID) was being displayed as `0345` instead of `345` on the callees phone even though the correct CID was being set in the [From parameter](https://www.twilio.com/docs/api/voice/making-calls#post-parameters) received by [Somleng's REST API](https://github.com/somleng/twilreapi).

Some configuration was modified on Shaqodoon's side in order to fix the issue.

### Technology Developed/Improved

#### Phony

Somleng uses [Phony](https://github.com/floere/phony) which is an open source library for validating phone numbers. [Multiple improvements](https://github.com/floere/phony/search?q=somalia&type=Issues) were made to [Phony](https://github.com/floere/phony) to provide more accurate validation of Somali phone numbers.

#### Torasup

Somleng uses [Torasup](https://github.com/somleng/torasup) (also developed by Somleng which is an open source library for returning metadata about a [Telco](https://en.wikipedia.org/wiki/Telephone_company) given a phone number) in order to route calls. [Multiple improvements](https://github.com/somleng/torasup/search?q=Somali&type=Commits) were made to [Torasup](https://github.com/somleng/torasup) to handle call routing of Somali phone numbers.

#### Automated Deployments and Upgrades

In order to manage deployments to multiple Somleng instances and automated deployment setup was created using various tools. The flow is descibed below:

1. Code is pushed to [Github](https://github.com/)
2. A new docker image is built on [Dockerhub](http://dockerhub.com/)
3. A [Dockerhub](http://dockerhub.com/) webhook triggers a build on [Travis](https://travis-ci.org/)
4. [Travis](https://travis-ci.org/) pulls the new Docker image and runs the automated test suite
5. If the tests pass a new version is automatically deployed to [Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/)

In order to make this process work we developed [Dockerhub2CI](https://github.com/somleng/dockerhub2ci) to intercept the Dockerhub Webhook and trigger a build on [Travis](https://travis-ci.org/).

#### Dynamic DNS (DDNS) for FreeSWITCH

The FreeSWITCH instance needs to have a static public IP address in order to be whitelisted by Shaqodoon. This can be setup using an [elastic IP address](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html) and an [Elastic Beanstalk Multi-Container Docker environment](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_ecs.html). Shaqodoon uses the FreeSWITCH instance's static public IP address in order to initiate calls on Somleng.

[Somleng-Adhearsion](https://github.com/somleng/somleng) on the other hand needs to be able to connect to the FreeSWITCH instance via its internal (private) IP address. The internal (private) IP address is assigned by AWS and is not static. The FreeSWITCH instance could be terminated due to an autoscaling event or an automatic upgrade.

The setup of a [Dynamic DNS (DDNS)](https://en.wikipedia.org/wiki/Dynamic_DNS) was developed and [documented](https://github.com/somleng/freeswitch-config/blob/master/docs/DDNS_CONFIGURATION.md) for FreeSWITCH. The DDNS allows [Somleng-Adhearsion](https://github.com/somleng/somleng) to connect to FreeSWITCH using an internal domain name instead of the private IP address. The DDNS automatically updates the mapping from the internal domain name to the private IP address if a scaling or upgrade occurs.

## Outcomes

This project greatly contributed to the improvement of Somleng. In particular the following outcomes were achieved.

### Somleng Simple Call Flow Manager (Somleng SCFM)

Because of the issues discovered in RapidPro relating to [retrying, throttling](https://github.com/rapidpro/rapidpro/issues/599) and [recording](https://github.com/rapidpro/rapidpro/issues/604) calls [Somleng Simple Call Flow Manager (Somleng SCFM)](https://github.com/somleng/somleng-scfm) was developed as an alternative to RapidPro for call flow management.

This doesn't mean that RapidPro is obsolete. For this project [Somleng SCFM](https://github.com/somleng/somleng-scfm) connects to RapidPro's API to trigger SMS flows for calls which were completed.

### RapidPro issues identified

The identification and documentation of [issue 599](https://github.com/rapidpro/rapidpro/issues/599) and [issue 604](https://github.com/rapidpro/rapidpro/issues/604) relating to RapidPro will hopefully lead to improvements in RapidPro being made.

### Call Recording

The ability to record calls through Somleng was the biggest improvement to Somleng itself. This improvement can now be used in future Somleng projects.

### Better Documentation

Deployment documentation for [Somleng's REST API](https://github.com/somleng/twilreapi/blob/master/docs/DEPLOYMENT.md), [Somleng-Adhearsion](https://github.com/somleng/somleng/blob/master/docs/DEPLOYMENT.md) and [FreeSWITCH](https://github.com/somleng/freeswitch-config/blob/master/docs/DEPLOYMENT.md) was improved as result of deploying Somleng to AWS for this project.

## Cost Savings

See [Somleng's Real Time Data](http://rtd.somleng.org/) for an up-to-date comparison of cost savings [compared to Twilio](https://www.twilio.com/voice/pricing/so)
