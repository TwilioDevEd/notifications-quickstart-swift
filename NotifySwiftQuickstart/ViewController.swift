//
//  ViewController.swift
//  notifications
//
//  Created by Siraj Raval on 2/24/16.
//  Copyright © 2016 twilio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var serverURL = "http://YOUR_SERVER_HERE"
  var path : String = "/register"

  @IBOutlet var registerButton: UIButton!
  @IBOutlet var identityField: UITextField!
  @IBOutlet var messageLabel: UILabel!


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func didTapRegister(_ sender: UIButton) {
    self.messageLabel.isHidden = true
    if (TARGET_OS_SIMULATOR == 1) {
      displayError("Unfortunately, push notifications don't work on the Simulator")
    } else {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let deviceToken : String! = appDelegate.devToken
      let identity : String! = self.identityField.text
      registerDevice(identity, deviceToken: deviceToken)
      resignFirstResponder()
    }
  }

  func displayError(_ errorMessage:String) {
    let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }

  func registerDevice(_ identity: String, deviceToken: String) {

    // Create a POST request to the /register endpoint with device variables to register for Twilio Notifications
    let session = URLSession.shared

    let url = URL(string: serverURL + path)
    var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
    request.httpMethod = "POST"

    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var params = ["identity": identity,
                  "BindingType" : "apn",
                  "Address" : deviceToken,
                  "Sandbox": appDelegate.environment == APNSEnvironment.development ? "True" : "False"]

    var endpoint = ""

    do {

        endpoint = try KeychainAccess.readEndpoint(identity: identity)
        params["endpoint"] = endpoint

        print("Successfully read endpoint: \(endpoint) from keychain for identity: \(identity) ")
    } catch let error  {
        print("Error retrieving endpoint from keychain: \(error)")
        //endpoint = identity+deviceToken
    }



    let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
    request.httpBody = jsonData

    let requestBody = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
    print("Request Body: \(requestBody)")

    let task = session.dataTask(with: request, completionHandler: {
        (responseData, response, error) in

      if let responseData = responseData {
        let responseString = String(data: responseData, encoding: String.Encoding.utf8)

        print("Response Body: \(responseString)")
        do {
            let responseObject = try JSONSerialization.jsonObject(with: responseData, options: [])
            if let responseDictionary = responseObject as? [String: Any] {
                if let message = responseDictionary["message"] as? String {
                    print("Message: \(message)")

                    DispatchQueue.main.async() {
                        self.messageLabel.text = message
                        self.messageLabel.isHidden = false
                    }
                }
                try KeychainAccess.saveEndpoint(identity: identity, endpoint: responseDictionary["endpoint"] as! String)

            }
            print("JSON: \(responseObject)")



        } catch let error {
            print("Error: \(error)")
        }
        }
    })

    task.resume()
  }



}
