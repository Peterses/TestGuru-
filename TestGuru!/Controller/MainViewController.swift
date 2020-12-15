//
//  ViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 24/09/2020.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        loginButton.layer.cornerRadius = 20
        registerButton.layer.cornerRadius = 20
        setupLayer(layer: loginButton.layer)
    }
    
    func setupLayer(layer: CALayer) {
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 2
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
