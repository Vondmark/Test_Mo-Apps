//
//  ViewController.swift
//  Test_Mo'Apps
//
//  Created by Mark on 08.05.2020.
//  Copyright © 2020 Mark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let networkService = NetworkingService()
    var autorizationResponse: AutorizationResponse? = nil
    
    @IBOutlet weak var logInTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var constVwX: NSLayoutConstraint!
    @IBOutlet weak var alpaView: UIView!
    @IBAction func informationButton(_ sender: UIButton) {
        constVwX.constant = 0
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.alpaView.alpha = 0.45
            self.logInTextField.isEnabled = false
            self.passwordTextField.isEnabled = false
            

        }, completion: nil)
    }
    @IBAction func continueButton(_ sender: UIButton) {
        constVwX.constant = -500
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.alpaView.alpha = 0
            self.logInTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            
        }, completion: nil)
    }
    
    var str:String = ""
    
    @IBAction func autorizationButtonAction(_ sender: UIButton) {
        if logInTextField.text == "" && passwordTextField.text == "" {
            errorLabel.alpha = 1
            errorLabel.text = "Заполните все поля"
        } else {
            let urlString = "https://html5.mo-apps.com/api/Account/Login"
            let parameters =  ["userNick" : logInTextField.text!, "password": passwordTextField.text!]
            self.networkService.autorizationRequest(urlString: urlString, parameters: parameters) { [weak self] (result) in
                switch result {
                case.success(let autorizationResponse):
                    self?.autorizationResponse = autorizationResponse
                    print(autorizationResponse.data)
                    DispatchQueue.main.async {
                        self?.str = String(autorizationResponse.data)
                        self?.performSegue(withIdentifier: "goTVC", sender: nil)
                    }
                case .failure(let error):
                    print("error", error)
                    self?.errorLabel.alpha = 1
                    self?.errorLabel.text = "Не верный логин или пароль"
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotification()
        delegateTextField()
    }
    
    //MARK: - TextFields
    
    func delegateTextField() {
        logInTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if logInTextField.isFirstResponder{
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Keyboard
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTVC" {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! TableViewController
            destinationVC.userToken = str;
        }
    }
}


