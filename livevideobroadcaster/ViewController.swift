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
    var userSession = UserDefaults()
    var userSessionExists : Bool = false
    @IBOutlet weak var heightEmailTF: NSLayoutConstraint!
    @IBOutlet weak var botConstraintLoginStack: NSLayoutConstraint!
    var keyboardHeight = CGFloat()
    @IBOutlet weak var centXConstraintUIStackView: NSLayoutConstraint!
    @IBOutlet weak var botConstraintUIStackView: NSLayoutConstraint!
    @IBOutlet weak var widthUIStackView: NSLayoutConstraint!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailTextField.autocorrectionType = .no
        passwordTextField.delegate = self
        passwordTextField.autocorrectionType = .no
        
        
        NotificationCenter.default.addObserver(self, selector: "keyboardWillShow:", name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: "keyboardWillHide:", name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        initUI()
        checkUserSessionStatus()
    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
    }
    
    func checkUserSessionStatus() {
        if (userSession.string(forKey: "userToken") != nil) {
            userSessionExists = true
            _ = userSession.string(forKey: "userToken")
            print("USER SESSION EXISTS")
            if (userSessionExists == true) {
                self.performSegue(withIdentifier: "segueScrollView", sender: self)
            }
        }
    }
    
    //MARK: Actions
    
    func checkConnection() -> Bool {
        let checkConnection = isInternetAvailable()
        
        if (checkConnection == true) {
            return true
        }
        
        else {
            return false
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        if (!checkConnection()) {
            let alert = alertUser(title: "Check connection", message: "Please check your internet connection and try again")
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
            if checkFields() == true {
                login(completion : { (loginResult) in
                    if (loginResult == true) {
                        self.performSegue(withIdentifier: "segueScrollView", sender: self)
                    }
                        
                    else {
                        let alert = alertUser(title: "Invalid Credentials", message: "Please check your email and/or password")
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
                
            else {
                let alert = alertUser(title: "Fields empty", message: "Please fill out the required fields")
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueScrollView") {
            let scrollViewVC = segue.destination as! ScrollViewVC
            scrollViewVC.passedToken += userToken
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
    
    func checkLoginStatus() {
        
    }
    
    func login(completion : @escaping (_ success : Bool) -> ()) {
        
        let timeString = String(NSDate().timeIntervalSince1970)
        let parameters = [
            "email" : emailTextField.text!,
            "password" : passwordTextField.text!,
            "time" : timeString]
        
        let loginURL = const.PROD_ROOT_URL + const.LOGIN_PATH
        
        Alamofire.request(URL(string: loginURL)!, method: .post, parameters: parameters, headers: nil)
        .validate()
        .responseJSON { (response) -> Void in
            if let httpError = response.result.error {
                print(httpError)
            }
            
            else if (response != nil) {
                _ = response.response?.statusCode
                let values = response.result.value as! [String: AnyObject]
                let valueInfo = String(values["status"] as! String)
                
                if (valueInfo == "success") {
                    let token = Token()
                    let tokenString = String(values["token"] as! String)
                    token.setUserToken(userToken: tokenString!)
                    token.setBearerUserToken(bearerUserToken: tokenString!)
                    self.userToken = String(values["token"] as! String)
                    self.userSession = UserDefaults.standard
                    self.userSession.set(self.userToken, forKey: "userToken")
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
        
        self.centXConstraintUIStackView.constant = 0
        
    }
    
    func labelTap(sender: UITapGestureRecognizer) {
        print("Tapped")
        
        if let url = NSURL(string: const.TERMS_OF_USE_URL){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
//            botConstraintLoginStack.constant = 200
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame : NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
//            botConstraintLoginStack.constant = 0
        }
    }
}


