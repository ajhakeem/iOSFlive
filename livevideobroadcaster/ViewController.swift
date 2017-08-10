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
    @IBOutlet weak var labelTermsAndPolicies: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    var isSuccessful : Bool = true
    var loginParams = [String : String]()
    var userToken = String()
    let const = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        
        initUI()
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
            
        }
    
    }
    
    func alertUser() {
        let alert = UIAlertController(title: "Invalid credentials", message: "Hello", preferredStyle: .alert)
        present(self, animated: true, completion: nil)
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
        
        let loginURL = const.ROOT_URL + const.LOGIN_PATH
        
        Alamofire.request(URL(string: loginURL)!, method: .post, parameters: parameters, headers: nil)
        .validate()
        .responseJSON { (response) -> Void in
            if (response != nil) {
                _ = response.response?.statusCode
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
    
    func initUI() {
        labelTermsAndPolicies.text = const.TERMS_AND_POLICIES_AGREEMENT
        let labelText = labelTermsAndPolicies.text!
        let underlineTermsAndPolicies = NSMutableAttributedString(string : labelText)
        let termsRange = (labelText as NSString).range(of: "Terms of Use")
        let policiesRange = (labelText as NSString).range(of: "Privacy Policy")
        underlineTermsAndPolicies.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: termsRange)
        underlineTermsAndPolicies.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: termsRange)
        underlineTermsAndPolicies.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: policiesRange)
        underlineTermsAndPolicies.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: policiesRange)
        
        labelTermsAndPolicies.attributedText = underlineTermsAndPolicies
        
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        
        let termsTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ViewController.labelTap(sender:)))
        labelTermsAndPolicies.isUserInteractionEnabled = true
        labelTermsAndPolicies.addGestureRecognizer(termsTapGesture)
        
    }
    
    func labelTap(sender: UITapGestureRecognizer) {
        print("Tapped")
        
        if let url = NSURL(string: const.TERMS_OF_USE_URL){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    
}


