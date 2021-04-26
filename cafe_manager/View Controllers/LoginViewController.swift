//
//  LoginViewController.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-26.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblError: UILabel!
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        lblError.alpha = 0
        self.txtPassword.delegate = self
    }
    
    func validateForm() -> String? {
        if txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            return "Please fill the form!"
        }
        return nil
    }
    
    func showError(_ message:String) {
        lblError.text = message
        lblError.alpha = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func navigateHome() {
        let tabViewController = storyboard?.instantiateViewController(identifier: "TabBarController")
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        
        let error = validateForm()
        
        if error != nil {
            showError(error!)
        } else {
            
            let email = txtEmail.text!
            let password = txtPassword.text!
            
            self.view.endEditing(true)
            
            if(email == "admin" && password == "123") {
                
                self.userDefaults.setValue("true",forKey: "LOGGED_IN")
                navigateHome()
                
            } else {
                self.showError("Invalid credentials!")
            }
        }
        
    }
}
