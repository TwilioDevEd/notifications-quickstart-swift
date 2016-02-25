//
//  ViewController.swift
//  notifications
//
//  Created by Siraj Raval on 2/24/16.
//  Copyright © 2016 twilio. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
  var serverURL : String = "http://YOUR_WEB_APP/register"

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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let deviceToken : String! = appDelegate.devToken
    let identity : String! = self.identityField.text
    registerDevice(identity, deviceToken: deviceToken)
  }
    
  func registerDevice(identity: String, deviceToken: String) {
    //Init request
    Alamofire.request(.POST, serverURL, parameters: ["identity": identity,
                                                    "endpoint" : identity+deviceToken,
                                                 "BindingType" : "apn",
                                                     "Address" : deviceToken])
            .responseJSON { response in
              let result = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
              if result != "Success" {
                print("Error: registration not successful")
              }
        }
    }
}

