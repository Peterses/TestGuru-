//
//  RegisterViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 24/09/2020.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registeringView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupLayer()
        emailTextField.addToolbar()
        passwordTextField.addToolbar()
        emailTextField.overrideUserInterfaceStyle = .light
        passwordTextField.overrideUserInterfaceStyle = .light
    }
    
    private func setupLayer() {
        registeringView.layer.cornerRadius = 15
        registerButton.layer.cornerRadius = 10
        registerButton.layer.shadowColor = UIColor.white.cgColor
        registerButton.layer.shadowOffset = .zero
        registerButton.layer.shadowOpacity = 0.6
        registerButton.layer.shadowRadius = 10
        registerButton.layer.shadowPath = UIBezierPath(rect: registerButton.bounds).cgPath
    }
    
    private func showActivityIndicator() {
        registeringView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func hideActivityIndicator() {
        self.activityIndicatorView.stopAnimating()
        registeringView.isHidden = true
    }

    // TODO: - to refactor alert
    @IBAction func registerButtonPressed(_ sender: Any) {
        showActivityIndicator()
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            hideActivityIndicator()
            let alert = UIAlertController(title: ErrorsDescription.error, message: ErrorsDescription.emailOrPasswordMissing, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: SuccessDescription.ok, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        DbManager.shared.registerUser(email: email, password: password) { (authResult, error) in
            let isRegistered = authResult ?? false
            if isRegistered {
                self.hideActivityIndicator()
                let alert = UIAlertController(title: SuccessDescription.success, message: SuccessDescription.registerSuccess, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: SuccessDescription.ok, style: UIAlertAction.Style.default, handler: { action in
                    self.performSegue(withIdentifier: Constants.registerToAppSegue, sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
            } else if !isRegistered {
                self.hideActivityIndicator()
                let alert = UIAlertController(title: ErrorsDescription.error, message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: SuccessDescription.ok, style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
