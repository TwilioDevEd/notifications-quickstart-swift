# notifications-quickstart-swift

Twilio Notifications starter iOS application in Swift

This application should give you a ready-made starting point for writing your
own notification-integrated apps with Twilio Notifications. Before we begin, you need to collected the credentials to run the notifications web app. 

Credential | Description
---------- | -----------
Twilio Account SID | Your main Twilio account identifier - [find it on your dashboard](https://www.twilio.com/user/account/settings).
Twilio Credential SID | Adds notification ability to your app - [generate one here](https://www.twilio.com/user/account/ip-messaging/credentials). You'll need to provision your APN push credentials to generate this. See [this](https://www.twilio.com/docs/api/ip-messaging/guides/push-notifications-ios) guide on how to do that.
Twilio Notification URL | The base URL for the Notifications API -- `https://notification.twilio.com`
Twilio Notification_Service SID | Use the create_service.js script to generate this. Just run 'node create_service.js' in your terminal.

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

Your application should now be running at [http://localhost:5000](http://localhost:5000). 

##Please Note
You'll need to test this on the device, since the iOS simulator can't receive notifications. To test on device, your server will need to be on the public Internet. For this, you might consider using a solution like [ngrok](https://ngrok.com/).

## Setting Up The iOS App
After downloading or cloning the app, in a terminal window enter the following

    'pod install'

This will install the necessary dependency (AlamoFire). Once it's installed you
can go ahead and open 'notifications.xcworkspace'. 

In the ViewController file, on this line,

    var serverURL : String = "http://YOUR_WEB_APP/register"

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
