//
//  ViewController.swift
//  notifications
//
//  Created by Siraj Raval on 2/24/16.
//  Copyright © 2016 twilio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var serverURL : String = "http://YOUR_SERVER_HERE/register"
  
  @IBOutlet var registerButton: UIButton!
  @IBOutlet var identityField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func didTapRegister(sender: UIButton) {
    if (TARGET_OS_SIMULATOR == 1) {
      displayError("Unfortunately, push notifications don't work on the Simulator")
    } else {
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let deviceToken : String! = appDelegate.devToken
      let identity : String! = self.identityField.text
      registerDevice(identity, deviceToken: deviceToken)
      resignFirstResponder()
    }
  }
  
  func displayError(errorMessage:String) {
    let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(okAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  func registerDevice(identity: String, deviceToken: String) {
    
    // Create a POST request to the /register endpoint with device variables to register for Twilio Notifications
    let session = NSURLSession.sharedSession()
    
    let url = NSURL(string: serverURL)
    let request = NSMutableURLRequest(URL: url!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 30.0)
    request.HTTPMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let params = ["identity": identity,
                  "endpoint" : identity+deviceToken,
                  "BindingType" : "apn",
                  "Address" : deviceToken]
    
    let jsonData = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
    request.HTTPBody = jsonData
    
    let requestBody = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
    print("Request Body: \(requestBody)")
    
    let task = session.dataTaskWithRequest(request) { (responseData:NSData?, response:NSURLResponse?, error:NSError?) in
      if let responseData = responseData {
        let responseString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
        print("Response Body: \(responseString)")
        do {
          let responseObject = try NSJSONSerialization.JSONObjectWithData(responseData, options: [])
          print("JSON: \(responseObject)")
        } catch let error {
          print("Error: \(error)")
        }
      }
    }
    task.resume()
  }
  
  
  
}

