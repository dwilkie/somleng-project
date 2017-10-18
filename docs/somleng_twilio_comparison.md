# Somleng vs Twilio Comparison

## Preface

This document assumes that you have some basic knowledge about what Somleng and Twilio are and how they work. If not, please go ahead and read about [Somleng](https://github.com/somleng/somleng-project/blob/master/docs/what_is_somleng.md) and [Twilio](https://github.com/somleng/somleng-project/blob/master/docs/what_is_twilio.md) first.

## Disclaimer

I'm the founder of Somleng and I [authored](https://github.com/somleng/somleng-project/commit/11e5eca86be878e81aaa020c63c5baa657503b5d) this document. This document is intended to be as [objective](https://www.google.com.kh/search?&q=define+objective) as possible when comparing Somleng with Twilio. If you see anything that's too subjective please open a [Pull Request](https://github.com/somleng/somleng-project/pulls).

## Feature Comparison

| Feature                   | Somleng  | Twilio   |
| :------------------------:|:--------:| :-------:|
| Features                  | Less     | More     |
| Voice                     | Yes      | Yes      |
| SMS                       | No*      | Yes      |
| Video                     | No*      | Yes      |
| Open Source               | Yes      | No       |
| PaaS                      | No       | Yes      |
| Ease of Getting Started   | Harder   | Easier   |
| Support Packages          | Yes      | Yes      |
| Customizable              | Yes      | No       |
| Deploy to own Servers     | Yes      | No       |
| Deal with your own telcos | Yes      | No       |
| Pricing                   | Free**   | Not Free |

* *Not yet but could be implemented
* **Somleng is free but you [may](https://github.com/somleng/somleng-project/blob/master/docs/case_study_africas_voices.md) or [may not](https://github.com/somleng/somleng-project/blob/master/docs/case_study_ews.md) need to pay your local telco or aggregator.

## Reasons why some people choose **Twilio** over Somleng

### Easier to get started

Because [Twilio is a PaaS (Platform as a Service)](https://en.wikipedia.org/wiki/Twilio) it's relatively simple to get something up an running. Just [sign up](https://www.twilio.com/try-twilio) for an account, purchase a number, write some [TwiML](https://www.twilio.com/docs/api/twiml), use the [REST API](https://www.twilio.com/docs/api/rest) and you're away.

Somleng on the other hand is Open Source so you have to install it yourself. Detailed technical documentation is available for deploying Somleng (for example [this guide](https://github.com/somleng/twilreapi/blob/master/docs/DEPLOYMENT.md) for deploying the REST API to AWS), however deployment requires some technical knowledge and know-how.

### More complete features

Some applications rely on features that Somleng does not yet support, for example SMS or Video calling. For applications that solely rely on features that are not supported by Somleng, Twilio is may be the best option. For applications that rely on a combination of features that are already supported by Somleng and that are not you may consider using a hybrid of both Twilio and Somleng.

### No relationship with Telcos/Aggregators

Somleng allows you to connect to your own Telco or Aggregator to deliver calls through mobile networks and landlines. Unlike Twilio, Somleng does not select the termination operator for you. If you don't have relationships with Telcos or Aggregators in your area consider choosing Twilio over Somleng.

## Reasons why some people choose **Somleng** over of Twilio

### Have your own relationship with a Telco/Aggrigator

If you have your own relationship with a Telco or Aggregator you can connect Somleng directly to them. In some cases such as the [Early Warning System (EWS)](https://github.com/somleng/somleng-project/blob/master/docs/case_study_ews.md) deployed in Cambodia, the [National Committee for Disaster Managment](http://www.ncdm.gov.kh/) in cooperation with the [Telecommunication Regulator of Cambodia](https://www.trc.gov.kh/en/) regulate that the EWS service must be provided free of charge by the operators.

### Want full control

Somleng lets you have full control over your stack. From the [REST API](https://github.com/somleng/twilreapi), to the [connection to your Telco or Aggregator](https://github.com/somleng/freeswitch-config), you can customize and deploy Somleng according to your specific needs and requirements.

### Twilio's too expensive

Twilio's pricing can be expensive particularly in developing countries in [Africa](https://www.twilio.com/voice/pricing/cf) and [Asia](https://www.twilio.com/voice/pricing/tl). If you [have your own relationship with a Telco/Aggrigator](https://github.com/somleng/somleng-project/blob/master/docs/somleng_twilio_comparison.md#have-your-own-relationship-with-a-telco) you may be able to get a much better deal from them than from Twilio.

### Twilio's quality is poor in your country

Twilio makes uses of aggrigators which may or may not be in your country in order to terminate calls. This sometimes can lead to poor call quality. Using Somleng and connecting to a local telco or aggrigator may result in increased call quality.

### You need a local number or short code which Twilio does not provide in your country

Twilio offers [international phone numbers](https://support.twilio.com/hc/en-us/articles/223183068-Twilio-international-phone-number-availability-and-their-capabilities) and short-codes for some but not all countries. If you need two-way voice calls in a country that Twilio does not support consider using Somleng.
