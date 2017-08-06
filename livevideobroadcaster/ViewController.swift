//
//  ViewController.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/2/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var fieldsValid : Bool = false
    var isSuccessful : Bool = true
    let authTest = AuthGateway()
    var loginParams = [String : String]()
    var loginURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        
    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if checkFields() == true {
            login()
        }
        
        else {
            emailTextField.placeholder = "Fields Invalid"
        }
    }
    
    func checkFields() -> Bool {
        if ((emailTextField.text?.isEmpty)! || emailTextField.text == nil || passwordTextField.text == nil) {
            fieldsValid = false
        }
        
        else {
            fieldsValid = true
        }
        
        return fieldsValid
    }
    
    func login() {
        
        let timeString = String(NSDate().timeIntervalSince1970 / 1000)
        let parameters = [
            "email" : emailTextField.text!,
            "password" : passwordTextField.text!,
            "time" : timeString]
        
        Alamofire.request(URL(string: "https://testapi.fbfanadnetwork.com/users/login.php")!, method: .post, parameters: parameters, headers: nil)
        .validate()
        .responseJSON { (response) -> Void in
            if (response != nil) {
                let statusMessage = response.response?.statusCode
                let values = response.result.value as! [String: AnyObject]
                let valueInfo = String(values["status"] as! String)
                
                if (valueInfo == "success") {
                 self.performSegue(withIdentifier: "segueBroadcaster", sender: nil)
                }
                
                else {
                    print("Invalid credentials")
                }
            }

            else {
                print("Sign-in error")
            }
        }
        
    }
    
}


