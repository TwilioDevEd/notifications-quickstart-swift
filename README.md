# Twilio Notify Quickstart for Swift

This application should give you a ready-made starting point for writing your
own notification-integrated apps with Twilio Notify. 

## Gather account information

We need to get the necessary information from our Twilio account. Here's what we'll need:

Config Value  | Description
:-------------  |:-------------
Service Instance SID | A [service](/docs/api/notifications/rest/services) instance where all the data for our application is stored and scoped. You can create one in the [console](/console/notify/services).

You will also need to create a push credential on the Twilio Console, and then configure it on your Notify service. You can [upload your push credentials here](/console/notify/credentials/create). If you haven't set up the Apple Push Notification Service (APNS) for your app, you can do so by following [the iOS push notification guide](/docs/api/notifications/guides/configuring-ios-push-notifications).

## Set up Twilio Functions

The sample mobile app is already set up to communicate with Twilio Functions to register a device for notifications. You just need to create two Functions in your account from a template, and then specify the URL for one of those Twilio Functions in the source code to the app.

To get started with this, create a new Twilio Function on the [Twilio Console's Manage Functions page](/console/runtime/functions/manage). Choose the Twilio Notify Quickstart template from the list of templates.
Use the Notify service SID you collected in the previous section for the only required configuration parameter for the template.

## Configure the Mobile App

You'll have a subdomain associated with your Twilio account - each account has a different one.

In the ViewController.swift file, on this line,

    var serverURL = "https://YOUR_DOMAIN_HERE.twil.io"
    
Change the serverURL to match your Twilio Functions subdomain.  
 
## Please Note
You'll need to test this on the device, since the iOS simulator can't receive notifications. 

Once you've entered your URL, you can compile and run the app. Enter an identity in the text field that's presented. 

Note that user identities for Notify should not be Personally Identifiable Information (PII), such as names. 

Once you tap register, the app will register your device with your Notify service and return a JSON response object to the app if successful. 

After that, send a notification to the identity you registered so that you will receive a push notification in your app. 

You can call the Twilio Function directly with an identity parameter and a body parameter, like this:

    https://sturdy-concrete-1657.twil.io/send-notification?identity=user1&body=Hello

That's it!

## License

MIT
