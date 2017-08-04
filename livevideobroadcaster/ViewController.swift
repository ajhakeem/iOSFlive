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
            loginParams["email"] = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            loginParams["password"] = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if (loginURL == nil) {
                    loginURL = authTest.setLoginPath()
                    login()
            }
            
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

    func getRequest() {
        Alamofire.request("https://httpbin.org/get")
        .responseJSON { (response) in
            if let JSON = response.result.value {
             print(JSON)
            }
        }
    }
    
    func login() {
        Alamofire.request(loginURL!, method: .post, parameters: loginParams, encoding: JSONEncoding.default)
        .responseJSON { (response2) in
            if let postResponse = response2.result.value {
                print(postResponse)
                print("SUCCESS!!!")
            }
            
            else {
                print("FAIL")
            }
        }

    }
    
    
}


