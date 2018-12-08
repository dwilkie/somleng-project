# Introduction to Somleng

By David Wilkie, CEO and Founder, Somleng

Last updated: 07 December 2018

Previous diffs and versions are available [here](https://github.com/somleng/somleng-project/commits/master/docs/introduction_for_development_organizations.md). Contributions and improvements [welcome](https://github.com/somleng/somleng-project/pulls).

## Cambodia

### The Early Warning System

Cambodia is a country consistently ranked as one of the most vulnerable to the effects of natural disasters.

In order to deliver timely and potentially lifesaving information to people in disaster prone areas, an Early Warning System (EWS) was conceived by the organization, [People In Need (PIN)](https://www.clovekvtisni.cz/en/what-we-do/humanitarian-aid-and-development/cambodia) <sup>[1](#footnote-ews-article)</sup>.

[PIN](https://www.clovekvtisni.cz/en/what-we-do/humanitarian-aid-and-development/cambodia) realized that the EWS needs to be accessible to all Cambodians, regardless of literacy and Internet connectivity issues.

They decided to look into a solution which uses voice based messaging for alerts and [Interactive Voice Response (IVR)](https://en.wikipedia.org/wiki/Interactive_voice_response) for registration. In collaboration with [UNICEF](https://www.unicef.org/cambodia), they decided to use [RapidPro](http://rapidpro.io/), an open-source platform of applications that delivers rapid and vital real-time information, to manage the registration of users into the system.

With help from the Royal Cambodian Government, the [Telecommunication Regulator of Cambodia (TRC)](https://www.trc.gov.kh) and the [National Committee for Disaster Management (NCDM)](http://www.ncdm.gov.kh/), it was regulated that the Early Warning System must be provided free of charge by the [Mobile Network Operators (MNOs)](https://en.wikipedia.org/wiki/Mobile_network_operator) in Cambodia.

With the pieces of the puzzle coming together the problems that still remained were:

1. How to connect RapidPro to the MNOs for user registration?
2. How to send out automated alerts to people at risk in the event of an emergency?

### Introduction to Somleng

[Somleng](http://www.somleng.org/) is an [Open Source](https://en.wikipedia.org/wiki/Open-source_software) implementation of [Twilio](https://www.twilio.com/). Unlike Twilio, Somleng gives you complete control over where it's connected to. Somleng can connect to [MNOs](https://en.wikipedia.org/wiki/Mobile_network_operator), [Telcos](https://en.wikipedia.org/wiki/Telephone_company), Aggregators or even your [own hardware](https://en.wikipedia.org/wiki/SIM_box).

Because [Somleng's REST API](https://github.com/somleng/twilreapi) is an open source implementation of [Twilio's REST API](https://www.twilio.com/docs/api/rest) you can swap Twilio out for Somleng in your existing applications seamlessly.

Unlike Twilio, there's no monthly or per-minute fees for using Somleng and all the code is Open Source and available on [Github](https://github.com/somleng).

### Registrations through RapidPro and Somleng

People in Need (PIN) use RapidPro to design callflows for registering for the Early Warning System. RapidPro connects to Somleng out of the box and Somleng connects to the MNOs to handle inbound registrations through the short code 1294.

### Automated Alerts through Somleng Simple Call Flow Manager

[Somleng Simple Call Flow Manager (Somleng SCFM)](https://github.com/somleng/somleng-scfm) is an Open Source call flow manager specifically designed for queuing, retrying, scheduling and analysis of calls. It comes complete with it's own REST API for managing contacts, callouts and phone calls. Flood sensors which detect water level heights are connected to Somelng SCFM, which then triggers automated alerts thorugh Somleng.

### Results

Somleng collects [Real Time Data](http://rtd.somleng.org) from the Early Warning System and other projects which is available at [http://rtd.somleng.org](http://rtd.somleng.org).

Since the beginning of the project Somleng has processed around [367 K](http://rtd.somleng.org) minutes worth of registrations and [94.7 K](http://rtd.somleng.org) minutes worth of alerts, resulting in a total cost saving of [$9,468.49 (100%)](http://rtd.somleng.org) if [compared with Twilio](https://www.twilio.com/voice/pricing/kh).

## Somalia

### Cash Assistance Package

In Somalia returnee households from Dadaab refugee camp in Kenya and vulnerable households in Bay and Bakool received emergency unconditional cash-based transfer assistance package to help them meet their needs during the current drought period.

In order to share information and get feedback about the program, a voice-based messaging solution was proposed. In the proposal voice messages and surveys would be recorded in the [Somali language](https://en.wikipedia.org/wiki/Somali_language) and delivered to the household head by mobile phone calls.

### Cost Concerns

The price for terminating a call through [Twilio](https://www.twilio.com/) in Somalia is [$0.7680 per minute](https://www.twilio.com/voice/pricing/so). To date AVF have sent around [75.8 K](http://rtd.somleng.org) minutes worth of calls which would equate to [$58,238.98](http://rtd.somleng.org) on Twilio.

In order to reduce costs and promote local businesses, AVF partnered with [Shaqodoon](http://shaqodoon.org/technology/), a local company which provides aggregation for Mobile Network Operators (MNOs) in Somalia. In comparison, Shaqodoon's pricing is between $0.04 and $0.07 per minute depending on the MNO.

With a potential solution to the economic feasibility of the project, the problems that still remained were:

1. How to design call flows
2. How to deliver calls through Shaqodoon

### RapidPro

In order to solve the first problem, AVF partnered with [UNICEF](https://www.unicef.org/somalia) and was given access to [RapidPro](http://rapidpro.io/) which can be used as a graphical interface for designing call flows.

### Somleng

The final problem that remained was how to deliver the calls through Shaqodoon.

Somleng is the missing piece of the puzzle. Somleng (which RapidPro connects out of the box) allows you to connect to the MNO, Telco or Aggregator of your choice. AVF used Somleng to connect Shaqodoon and have so far saved [$54,874.75 (94%)](http://rtd.somleng.org) if [compared with Twilio](https://www.twilio.com/voice/pricing/so).

### Scaling Issues

After using the RapidPro -> Somleng -> Shaqodoon solution for some time AVF ran into some scaling issues. The first problem was a [limitation in Shaqodoon](https://github.com/somleng/somleng-project/blob/master/docs/case_study_africas_voices.md#shaqadoon) that restricted callouts to a maximum of 32 simultaneous calls per MNO.

The obvious solution would be to retry failed calls through RapidPro but unfortunately RapidPro [does not yet have a solution](https://github.com/rapidpro/rapidpro/issues/599) for this.

The second problem was that AVF wanted to have more control over when the calls were sent out. In particular they wanted to pause calls during certain times of the day (e.g. prayer time) and at night.

### Solutions

[Somleng Simple Call Flow Manager (Somleng SCFM)](https://github.com/somleng/somleng-scfm) was developed specifically to solve the aforementioned problems. Somleng SCFM connects to Somleng directly (bypassing RapidPro) and controls the retrying and scheduling of calls. This gives the user complete control over which calls are retried and when, as well as when they will be scheduled. AVF still uses RapidPro to trigger SMS flows which are scheduled by Somleng SCFM. Our [technical write up](https://github.com/somleng/somleng-project/blob/master/docs/case_study_africas_voices.md) contains more information about the project from a technical perspective.

## Contact

For more information about Somleng please contact David Wilkie at [dave@somleng.org](mailto:dave@somleng.org)

## References

<a name="footnote-ews-article"><sup>1</sup></a> [New innovations protecting lives in flood-prone Cambodia](http://unicefstories.org/2017/06/20/new-innovations-protecting-lives-in-flood-prone-cambodia/)

<a name="footnote-somleng-rtd"><sup>2</sup></a> [Somleng Real Time Data](http://rtd.somleng.org)
