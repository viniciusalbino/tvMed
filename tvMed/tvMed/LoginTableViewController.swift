//
//  LoginTableViewController.swift
//  tvMed
//
//  Created by Vinicius Albino on 16/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//
import UIKit
import Foundation
import FirebaseAuth

class LoginTableViewController: UITableViewController,KeyboardToolbarDelegate, UITextFieldDelegate, LoadingProtocol, ValidatesPassword,ValidatesUsername {
    
    @IBOutlet weak var loginTextField:AnnotatedTextField!
    @IBOutlet weak var passTextField:AnnotatedTextField!
    @IBOutlet weak var loginButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        self.checkLoggedUser()
        self.addInputFields()
    }
    
    func checkLoggedUser()  {
        guard KeychainWrapperManager.checkLoggedUser() else {
            return
        }
        self.performSegueWithIdentifier("homePush", sender: self)
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .min
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .min
    }
    
    func resignAllTextFieldsResponder() {
        self.textFields()?.forEach{$0.resignFirstResponder()}
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.loginTextField {
            self.passTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func makeLogin() {
        guard self.validateLogin() else {
            UIAlertView.showDefaultAlertWithMessage(NSLocalizedString("Login / senha inválidos", comment: ""))
            return
        }
        self.resignAllTextFieldsResponder()
        self.startLoading()
        
        FirebaseConnection.loginUser(self.loginTextField.text!, userPassword: self.passTextField.text!) { user, error in
            guard error == nil else {
                self.stopLoading()
                UIAlertView.showDefaultAlertWithMessage(error!)
                return
            }
            
            self.stopLoading()
            user?.saveUser()
            self.performSegueWithIdentifier("homePush", sender: self)
        }
    }
    
    func validateLogin() -> Bool {
        guard isUsernameValid(self.loginTextField?.text ?? "") && isPasswordValid(self.passTextField?.text ?? "") else {
            return false
        }
        return true
    }
    
    func addInputFields() {
        self.loginTextField.delegate = self
        self.loginTextField.addFocusChangingToolBarWithDelegate(self)
    }
    
    func toolbar(toolbar: KeyboardToolbar, didClickNext next: ZBarButtonItem, textField: UITextField) {
        TextFieldFirstResponderBouncer.bounceTextFieldForwards(textField, textFields: self.textFields()!)
    }
    
    func toolbar(toolbar: KeyboardToolbar, didClickPrevious previous: ZBarButtonItem, textField: UITextField) {
        TextFieldFirstResponderBouncer.bounceTextFieldBackwards(textField, textFields: self.textFields()!)
    }
    
    func textFields() -> [UITextField]? {
        return [self.loginTextField, self.passTextField]
    }
    
    @IBAction func signUpDidTouch() {
        
        let alert = UIAlertController(title: "Registro",
                                      message: "Registrar novo usuário",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Salvar",
                                       style: .Default) { action in
                                        
        let emailField = alert.textFields![0]
        let passwordField = alert.textFields![1]
        guard self.isUsernameValid(emailField.text ?? "") && self.isPasswordValid(passwordField.text ?? "") else {
            UIAlertView.showDefaultAlertWithMessage(NSLocalizedString("Login / senha inválidos", comment: ""))
            return
        }
        self.startLoading()
        FirebaseConnection.registerUser(emailField.text!, userPassword: passwordField.text!, callback: { user, error in
            guard error == nil else {
                self.stopLoading()
                UIAlertView.showDefaultAlertWithMessage(error!)
                return
            }
                FirebaseConnection.loginUser(emailField.text!, userPassword: passwordField.text!, callback: { user, error in
                    guard error == nil else {
                        self.stopLoading()
                        UIAlertView.showDefaultAlertWithMessage(error!)
                        return
                    }
                    user?.saveUser()
                    self.stopLoading()
                    self.performSegueWithIdentifier("homePush", sender: self)
                })
            })
        }
        
        let cancelAction =  UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler { textEmail in
            textEmail.placeholder = "E-mail"
        }
        
        alert.addTextFieldWithConfigurationHandler { textPassword in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Senha"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
}
