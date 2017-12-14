//
//  AppDelegate.swift
//  notifications
//
//  Created by Siraj Raval on 2/24/16.
//  Copyright © 2016 twilio. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var devToken: String?
  var environment: APNSEnvironment?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    if #available(iOS 10, *) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
    } else {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    self.environment = ProvisioningProfileInspector().apnsEnvironment()
    var envString = "Unknown"
    if environment != APNSEnvironment.unknown {
        if environment == APNSEnvironment.development {
            envString = "Development"
        } else {
            envString = "Production"
        }
    }
    print("APNS Environment detected as: \(envString) ");

    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
    var tokenString = ""
    for i in 0..<deviceToken.count {
      tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
    }
    print("Received token data! \(tokenString)")
    devToken = tokenString
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Couldn't register: \(error)")
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    print("Message received.")
    if let aps = userInfo[AnyHashable("aps")] as? [AnyHashable: Any] {
        let message = aps[AnyHashable("alert")] as? String
        let alertController = UIAlertController(title: "Notification", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
  }
}

