# What is Somleng?

## Preface

This document assumes that you have a basic understanding of what [Twilio](https://www.twilio.com/) is and how it works. If not, please go ahead and [read about](https://github.com/somleng/somleng-project/blob/master/docs/what_is_twilio.md) Twilio first.

## Introduction

Somleng is an [Open Source](https://en.wikipedia.org/wiki/Open-source_software) implementation of [Twilio](https://www.twilio.com/). Although Somleng currently only supports a subset of the features that Twilio supports it can be used in many cases as a drop-in replacement for Twilio.

## How does it work?

Somleng's [Twilreapi (Twilio REST API)](https://github.com/somleng/twilreapi) is an Open Source implementation of [Twilio's REST API](https://www.twilio.com/docs/api/rest). Although Twilreapi currently only supports a subset of Twilio's API endpoints, the endpoint that it does support are almost identical to the ones implemented by Twilio's REST API.

This means that you can use any of [Twilio's Helper Libraries](https://www.twilio.com/docs/libraries) in your favourite programming language and with a few [minor code changes](https://github.com/somleng/somleng-scfm/tree/master/app/http_clients/somleng/rest) your application can be talking to Somleng instead of Twilio.

## Why would I want to use Somleng instead of Twilio?

Please see [Somleng vs Twilio Comparison](https://github.com/somleng/somleng-project/blob/master/docs/somleng_twilio_comparison.md) for a detailed comparision of Twilio vs Somleng and reasons why you may or may not want to choose Somleng instead of Twilio.

