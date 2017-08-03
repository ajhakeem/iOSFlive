//
//  ViewController.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/2/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var fieldsValid : Bool = false
    var isSuccessful : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if checkFields() == true {
            let authTest = AuthGateway()
            emailTextField.placeholder = authTest.LOGIN_PATH
            //authTest.runTest(number: 5, completionHandler: <#(Bool) -> Void#>)
            let postTest = Post()
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

}

struct userLoginTask {
    var userEmail : String
    var userPassword : String
    var authGateway = AuthGateway()
    var loginParams = [String : String]()
    var response = [String : NSObject]()
    
    init(email : String, password : String) {
        self.userEmail = email
        self.userPassword = password
        loginParams["email"] = userEmail
        loginParams["password"] = userPassword
    }
    
    func execute() {
        authGateway.login(params: loginParams)
        
    }

}

