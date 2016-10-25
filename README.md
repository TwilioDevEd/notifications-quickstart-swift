# notifications-quickstart-swift

Twilio Notifications starter iOS application in Swift

This application should give you a ready-made starting point for writing your
own notification-integrated apps with Twilio Notify. Before we begin, you need to collected the credentials to run the notifications web app. 

Credential | Description
---------- | -----------
Twilio Account SID | Your main Twilio account identifier - [find it on your dashboard](https://www.twilio.com/user/account/settings).
Twilio Credential SID | Adds notification ability to your app - [generate one here](https://www.twilio.com/user/account/ip-messaging/credentials). You'll need to provision your APN push credentials to generate this. See [this](https://www.twilio.com/docs/api/ip-messaging/guides/push-notifications-ios) guide on how to do that.
Twilio Notification_Service SID | Use the create_service.js script to generate this. Just run 'node create_service.js' in your terminal after setting up the credentials in your node web app's `config.json`

You can download the Node notifications web app from [here](https://github.com/TwilioDevEd/notifications-quickstart-node).
##Setting up the web app
Edit `config.json` with the four configuration parameters we gathered from above.

Next, we need to install our dependencies from npm:

```bash
npm install
```

Now we should be all set! Run the application using the `npm` command.

```bash
npm start
```

Your application should now be running at [http://localhost:3000](http://localhost:3000). 

##Please Note
You'll need to test this on the device, since the iOS simulator can't receive notifications. To test on device, your server will need to be on the public Internet. For this, you might consider using a solution like [ngrok](https://ngrok.com/).

## Setting Up The iOS App

To receive push notifications on your device, you will need to have an app ID registered with your Apple account. Change the Bundle Identifier from `com.twilio.notify.NotifySwiftQuickstart` to match your new App ID. You'll need to create APN push credentials for that app ID - for more, see the [Push Notifications for iOS Guide](https://www.twilio.com/docs/api/ip-messaging/guides/push-notifications-ios).

In the ViewController.swift file, on this line,

    var serverURL : String = "http://YOUR_SERVER_HERE/register"

Replace the URL with the address of your server. The app uses 4 credentials to register your device for notifications.

Credential | Description
---------- | -----------
Identity | This is how the web app identifies an individual user as the receiver of notifications.
Endpoint | This is a unique device ID and identity combination that can receive a message. (i.e Alice on her iPad is a different notification destination than Alice on her iPhone).
Bindingtype | This lets the web app know which service to register with (APNS or GCM).
Address | This is the unique device identifier of the mobile client.

Once you've entered your URL, you can compile & run the app. Enter in an identity in the text field that's presented. Once you tap register, the app will register your device with APNS and return a JSON response object if successful. After that, run the notify.js script in the web app repo

    node notify.js YOUR_IDENTITY

To receive a notification in your app. 

That's it!

## License

MIT
