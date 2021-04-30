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
    
    private let validation: ValidationService
    
    init(validation: ValidationService) {
        self.validation = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.validation = ValidationService()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        lblError.alpha = 0
        self.txtPassword.delegate = self
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
        
        do {
            let email = try validation.validateEmail(txtEmail.text!)
            let password = try validation.validatePassword(txtPassword.text!)
            
            self.view.endEditing(true)
            
            if (email == "admin" && password == "123") {
                
                self.userDefaults.setValue("true",forKey: "LOGGED_IN")
                navigateHome()
                
            } else {
                self.showError("Invalid credentials!")
            }
            
        } catch {
            showError(error.localizedDescription)
        }
    }
}
