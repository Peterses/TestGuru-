//
//  EditTestViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 30/10/2020.
//

import UIKit
import JGProgressHUD

class EditTestViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var questionsButton: UIButton!
    @IBOutlet weak var editTestButton: UIButton!
    @IBOutlet weak var difficultySegementedControl: UISegmentedControl!
    @IBOutlet weak var timeSlider: UISlider!
    
    public var test: TestModel?
    
    private var categories: [CategoryModel] = []
    private var categoryPickerView = UIPickerView()
    private let pickerCategoryTag = 1
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        let disclosure = UITableViewCell()
        disclosure.frame = questionsButton.bounds
        disclosure.tintColor = UIColor.white
        disclosure.accessoryType = .detailButton
        disclosure.isUserInteractionEnabled = false
        questionsButton.addSubview(disclosure)
        
        questionsButton.addTopBorderWithColor(color: UIColor.white, width: 0.3)
        questionsButton.addBottomBorderWithColor(color: UIColor.white, width: 0.3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegatesAndDatasources()
        setInputViews()
        
        difficultySegementedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        difficultySegementedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.clipsToBounds = true
        
        addToolBarToPickerView()
        
        categoryPickerView.tag = pickerCategoryTag
        
        loadTestParametersToView()
        nameTextField.overrideUserInterfaceStyle = .light
        categoryTextField.overrideUserInterfaceStyle = .light
        timeTextField.overrideUserInterfaceStyle = .light
        descriptionTextView.overrideUserInterfaceStyle = .light
    }
    
    private func setupDelegatesAndDatasources() {
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        descriptionTextView.delegate = self
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
    
    private func loadTestParametersToView() {
        guard let test = test else {
            print("Empty test!")
            return
        }
        nameTextField.text = test.name
        categoryTextField.text = test.category
        descriptionTextView.text = test.description
        
        // TODO: - do sth with this
        if test.difficultyLevel == "Łatwy" {
            difficultySegementedControl.selectedSegmentIndex = 0
        } else if test.difficultyLevel == "Średni" {
            difficultySegementedControl.selectedSegmentIndex = 1
        } else {
            difficultySegementedControl.selectedSegmentIndex = 2
        }
        timeTextField.text = String(test.time)
        timeSlider.value = Float(test.time)
    }
    
    private func setInputViews() {
        categoryTextField.inputView = categoryPickerView
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
    
    @objc func doneAction() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showQuestionsSegue {
            let vc = segue.destination as? AddQuestionsViewController
            vc?.test = sender as? TestModel
        }
    }
    
    // MARK: - @IBAction
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        let value = Int(sender.value)
        timeTextField.text = String(value)
    }
    
    @IBAction func questionsButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: Constants.showQuestionsSegue, sender: test)
    }
    
    @IBAction func editTestButtonClicked(_ sender: Any) {
        guard let oldTest = self.test, let name = nameTextField.text, let category = categoryTextField.text, let description = descriptionTextView.text, let time = timeTextField.text, let timeInt = Int(time) else {
            return
        }
        
        let difficultyLevelIndex = difficultySegementedControl.selectedSegmentIndex
        var difficultyLevel = ""
                
        if difficultyLevelIndex == 1 {
            difficultyLevel = "Łatwy"
        } else if difficultyLevelIndex == 2 {
            difficultyLevel = "Średni"
        } else {
            difficultyLevel = "Trudny"
        }
        
        let updatedTest: TestModel = TestModel(id: oldTest.id, name: name, category: category, description: description, difficultyLevel: difficultyLevel, rating: oldTest.rating, ratingsCounter: oldTest.ratingsCounter, time: timeInt, popularity: oldTest.popularity, questions: oldTest.questions, owner: oldTest.owner)
        
        DbManager.shared.updateTest(test: updatedTest) { [weak self] (isSuccess) in
            if isSuccess {
                let successHud = JGProgressHUD()
                successHud.textLabel.text = "Edytowano"
                successHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                successHud.show(in: (self?.view)!, animated: true)
                successHud.dismiss(afterDelay: 0.5)
            } else {
                let errorHud = JGProgressHUD()
                errorHud.textLabel.text = "Błąd edycji"
                errorHud.indicatorView = JGProgressHUDErrorIndicatorView()
                errorHud.show(in: (self?.view)!, animated: true)
                errorHud.dismiss(afterDelay: 0.5)
            }
        }
    }
}

// MARK: - PickerViewDelegate
extension EditTestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
extension EditTestViewController: UITextViewDelegate {
    
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
    
//    func textViewDidChange(_ textView: UITextView) {
//        if (textView.text == "")
//        {
//            textView.text = "Opis testu"
//            textView.textColor = .lightGray
//        }
//    }
}
