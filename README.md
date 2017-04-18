# Twilio Notify Quickstart for Swift

This application should give you a ready-made starting point for writing your
own notification-integrated apps with Twilio Notify. Before we begin, you will need to set up a web application that communicates with your mobile app

## Download a Twilio SDK Starter Server project

Luckily, we have built server applications for many languages:

| Language  | GitHub Repo |
| :-------------  |:------------- |
PHP | [sdk-starter-php](https://github.com/TwilioDevEd/sdk-starter-php/)
Ruby | [sdk-starter-ruby](https://github.com/TwilioDevEd/sdk-starter-ruby/)
Python | [sdk-starter-python](https://github.com/TwilioDevEd/sdk-starter-python/)
Node.js | [sdk-starter-node](https://github.com/TwilioDevEd/sdk-starter-node/)
Java | [sdk-starter-java](https://github.com/TwilioDevEd/sdk-starter-java/)

You'll only need to download one of those. Not sure which one to choose? The [Node.js](https://github.com/TwilioDevEd/sdk-starter-node/) server starter kit is pretty easy to set up and follow along with.

Follow the directions in the README on one of the above servers, and get the web client up and running to make sure you have everything configured right for the demos you are interested in.  

##Please Note
You'll need to test this on the device, since the iOS simulator can't receive notifications. To test on a device, your server will need to be on the public Internet. For this, you might consider using a solution like [ngrok](https://ngrok.com/).

In the ViewController.swift file, on this line,

    var serverURL : String = "http://YOUR_SERVER_HERE/register"

Replace the URL with the address of your server. The app uses 4 credentials to register your device for notifications.

Credential | Description
---------- | -----------
Identity | This is how the web app identifies an individual user as the receiver of notifications.
Endpoint | This is a unique device ID and identity combination that can receive a message. (i.e Alice on her iPad is a different notification destination than Alice on her iPhone).
Bindingtype | This lets the web app know which service to register with (APNS or GCM).
Address | This is the unique device identifier of the mobile client.

Once you've entered your URL, you can compile and run the app. Enter an identity in the text field that's presented. Once you tap register, the app will register your device with APNS and return a JSON response object if successful. After that, visit the Notify page on your server web application, and send a notification to the identity you registered as to receive a push notification in your app.

That's it!

## License

MIT
