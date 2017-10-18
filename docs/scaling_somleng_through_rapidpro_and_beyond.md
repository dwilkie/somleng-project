# Scaling Somleng through RapidPro and Beyond

## Preface

This document assumes that you have some basic knowledge about [Somleng](https://github.com/somleng/somleng-project/blob/master/docs/what_is_somleng.md), [Twilio](https://github.com/somleng/somleng-project/blob/master/docs/what_is_twilio.md) and [RapidPro](https://community.rapidpro.io/) and that you have a basic understanding about the [differences between Somleng and Twilio](https://github.com/somleng/somleng-project/blob/master/docs/somleng_twilio_comparison.md).

## Introduction

With the addition of the TwiML compliant channel, RapidPro now supports both Twilio and Somleng out of the box.

This means that you can connect your RapidPro flow to a Somleng instance and deliver or receive calls through your local telco or Mobile Network Operator (MNO).

## Getting Started

In order for Somleng to make or receive calls it must be connected to a [Telco](https://en.wikipedia.org/wiki/Telephone_company), [Mobile Network Operator (MNO)](https://en.wikipedia.org/wiki/Mobile_network_operator), [Aggregator](https://en.wikipedia.org/wiki/SIP_provider) or [SIM Box](https://en.wikipedia.org/wiki/SIM_box). Unlike Twilio, Somleng leaves it up to you to reach your own deal with these service providers. If you don't want to do this yourself [consider using Twilio instead](https://github.com/somleng/somleng-project/blob/master/docs/somleng_twilio_comparison.md).

The easiest way to connect to a Telco, MNO or Aggrigator (Service Provider) is through [SIP](https://en.wikipedia.org/wiki/Session_Initiation_Protocol). Ask your service provider if they support SIP access. If your service provider does not provide SIP access it still may be possible to connect to them depending on their alternatives. Feel free to [reach out](#more-info) for more info.

Once the connection to the service provider has been sorted out it's relatively simple to configure RapidPro to connect to Somleng using he TwiML compliant channel.

## Limitations

There are some [open issues](https://github.com/rapidpro/rapidpro/issues?&q=somleng) relating to [call retries](https://github.com/rapidpro/rapidpro/issues/599) and [recording](https://github.com/rapidpro/rapidpro/issues/604) with RapidPro connected to either Somleng or Twilio. Other than that everything should work as expected. If you need these features consider using [Somleng Simple Call Flow Manager (Somleng SCFM)](https://github.com/somleng/somleng-scfm). See below for more details.

## Alternatives

[Somleng Simple Call Flow Manager (Somleng SCFM)](https://github.com/somleng/somleng-scfm) can be used as an alternative or in conjunction with RapidPro. Somleng SCFM is designed to work with both Somleng and Twilio out of the box. It provides advanced features for queuing, retrying, scheduling and analysis of calls. See below for more details on how it's used in a case study.

## Case Studies

Africa's Voices Foundation (AVF) uses a combination of [RapidPro](https://community.rapidpro.io/) and [Somleng SCFM](https://github.com/somleng/somleng-scfm) to deliver calls and SMS to people in remote areas of Somalia. See the [case study](https://github.com/somleng/somleng-project/blob/master/docs/case_study_africas_voices.md) for more info.

People in Need (PIN) uses [Somleng SCFM](https://github.com/somleng/somleng-scfm) to deliver calls to the mobile phone of [people at risk of flooding](http://unicefstories.org/2017/06/20/new-innovations-protecting-lives-in-flood-prone-cambodia/). [RapidPro](https://community.rapidpro.io/) is used to for inbound calls to handle registration. See the [case study](https://github.com/somleng/somleng-project/blob/master/docs/case_study_ews.md) for more info.

## More Info

Please contact [dave@somleng.org](mailto:dave@somleng.org) for more info about Somleng.
