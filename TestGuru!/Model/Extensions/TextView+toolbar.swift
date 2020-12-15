//
//  TextField+extension.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 01/11/2020.
//

import UIKit

extension UITextView {
    func addToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let clear = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clickedClear))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(clickedDone))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([clear, spaceBtn, done], animated: true)
        self.inputAccessoryView = toolbar
    }
    
    @objc func clickedClear() {
        self.text = ""
    }
    
    @objc func clickedDone() {
        self.endEditing(true)
    }
}

