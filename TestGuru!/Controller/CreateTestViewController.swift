//
//  CreateTestViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 19/10/2020.
//

import UIKit

class CreateTestViewController: UIViewController {
    
    @IBOutlet weak var titleViewLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var createTestButton: UIButton!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var timeSlider: UISlider!
    
    private var categories: [CategoryModel] = []
    private var categoryPickerView = UIPickerView()
    private let pickerCategoryTag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCategories()
        difficultySegmentedControl.selectedSegmentIndex = 1
        
        addToolBarToPickerView()
        
        difficultySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        difficultySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.clipsToBounds = true
        
        setInputViews()
        setupDelegatesAndDatasources()
        categoryPickerView.tag = pickerCategoryTag
        
        descriptionTextView.text = "Opis testu"
        descriptionTextView.textColor = .lightGray
        nameTextField.overrideUserInterfaceStyle = .light
        categoryTextField.overrideUserInterfaceStyle = .light
        timeTextField.overrideUserInterfaceStyle = .light
        descriptionTextView.overrideUserInterfaceStyle = .light
    }
    
    private func getAllCategories() {
        DbManager.shared.getAllCategories { [weak self] (categories, isSuccess) in
            guard let me = self else {
                return
            }
            
            if let success = isSuccess, success {
                me.categories = categories ?? []
            } else {
                print("We have unexpected error here!")
            }
        }
    }
    
    @objc func doneAction() {
        view.endEditing(true)
    }
    
    private func addToolBarToPickerView() {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: #selector(self.doneAction))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceBtn, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        
        categoryTextField.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setInputViews() {
        categoryTextField.inputView = categoryPickerView
    }
    
    private func setupDelegatesAndDatasources() {
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        descriptionTextView.delegate = self
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        let value = Int(sender.value)
        timeTextField.text = String(value)
    }
    
    @IBAction func createTestButtonClicked(_ sender: Any) {
        
        guard let name = nameTextField.text, !name.isEmpty, let category = categoryTextField.text, !category.isEmpty, let difficultyLevel = difficultySegmentedControl.titleForSegment(at: difficultySegmentedControl.selectedSegmentIndex), !difficultyLevel.isEmpty, let time = timeTextField.text, !time.isEmpty, let user = DbManager.shared.getCurrentUser() else {
            print("There is no data available to create an object!")
            let alert = UIAlertController.init(title: ErrorsDescription.error, message: ErrorsDescription.missingData, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: SuccessDescription.ok, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let testDescription = descriptionTextView.text
        let timeInt = Int(time) ?? 0
        let questions: [QuestionModel] = []
        
        let test: TestModel = TestModel.init(id: nil, name: name, category: category, description: testDescription, difficultyLevel: difficultyLevel, rating: 0.0, ratingsCounter: 0, time: timeInt, popularity: 0, questions: questions, owner: user)
        
        DbManager.shared.saveTest(test: test) { (isSuccess) in
            if(isSuccess) {
                let alert = UIAlertController.init(title: SuccessDescription.success, message: "Prawidłowo utworzono test", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Wróć do Moje Testy", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else if (!isSuccess) {
                let alert = UIAlertController.init(title: SuccessDescription.success, message: "Błąd podczas tworzenia testu. Spróbuj ponownie.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - PickerViewDelegate
extension CreateTestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case self.pickerCategoryTag:
            return categories.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case self.pickerCategoryTag:
            return categories[row].name
        default:
            return "Data not found."
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case self.pickerCategoryTag:
            categoryTextField.text = categories[row].name
        default:
            return
        }
    }
}

// MARK: - TextViewDelegate
extension CreateTestViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Opis testu" && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "")
        {
            textView.text = "Opis testu"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
