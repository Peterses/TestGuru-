//
//  LoginViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 24/09/2020.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loggingView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        emailLoginTextField.addToolbar()
        passwordLoginTextField.addToolbar()
        setupLayer()
    }
    
    func setupLayer() {
        loginButton.layer.cornerRadius = 15
        loginButton.layer.shadowColor = UIColor.white.cgColor
        loginButton.layer.shadowOffset = .zero
        loginButton.layer.shadowOpacity = 0.6
        loginButton.layer.shadowRadius = 10
        loginButton.layer.shadowPath = UIBezierPath(rect: loginButton.bounds).cgPath
        loggingView.layer.cornerRadius = 15
        emailLoginTextField.overrideUserInterfaceStyle = .light
        passwordLoginTextField.overrideUserInterfaceStyle = .light
    }
    
    private func showActivityIndicator() {
        loggingView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func hideActivityIndicator() {
        self.activityIndicatorView.stopAnimating()
        loggingView.isHidden = true
    }
    
    // MARK: - @IBAction
    @IBAction func loginButtonPressed(_ sender: Any) {
        showActivityIndicator()
        guard let email = emailLoginTextField.text, let password = passwordLoginTextField.text, !email.isEmpty, !password.isEmpty  else {
            hideActivityIndicator()
            let alert = UIAlertController(title: ErrorsDescription.error, message: ErrorsDescription.emailOrPasswordMissing, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: SuccessDescription.ok, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        DbManager.shared.signInUser(email: email, password: password) { (authResult, error) in
            if authResult == false {
                self.hideActivityIndicator()
                let alert = UIAlertController(title: ErrorsDescription.error, message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: SuccessDescription.ok, style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if authResult == true {
                self.hideActivityIndicator()
                self.performSegue(withIdentifier: Constants.mainSegue, sender: self)
            }
        }
    }
}
