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
    var userToken = String()
    
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
    
    @IBAction func broadcastButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueBroadcast", sender: self)
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if checkFields() == true {
            login(completion : { (loginResult) in
                if (loginResult == true) {
                    self.performSegue(withIdentifier: "segueScrollView", sender: self)
                }
                
                else {
                    print("Invalid credentials")
                }
            })
        }
        
        else {
            emailTextField.placeholder = "Fields Invalid"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueScrollView") {
            let scrollViewVC = segue.destination as! ScrollViewVC
            scrollViewVC.passedToken += userToken
        }
        
        if (segue.identifier == "segueBroadcast") {
            _ = segue.destination as! LiveKitVC
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
    
    func login(completion : @escaping (_ success : Bool) -> ()) {
        
        let timeString = String(NSDate().timeIntervalSince1970)
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
                    let token = Token()
                    token.setUserToken(userToken: String(values["token"] as! String))
                    self.userToken = String(values["token"] as! String)
                    completion(true)
                }
                
                else {
                    completion(false)
                }
            }

            else {
                print("Sign-in error")
            }
        }
        
    }
    
}


