//
//  AddQuestionViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 31/10/2020.
//

import UIKit
import JGProgressHUD

// TODO: - scrollView on keyboard !!!!, - character limit to textView?

class AddQuestionViewController: UIViewController {
    
    @IBOutlet weak var questionNameTextView: UITextView!
    @IBOutlet weak var answerCorrectTextView: UITextView!
    @IBOutlet weak var answerWrong1TextView: UITextView!
    @IBOutlet weak var answerWrong2TextView: UITextView!
    @IBOutlet weak var answerWrong3TextView: UITextView!
    @IBOutlet weak var addQuestionButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    private var answersWrongTextViews: [UITextView] = []
    public var test: TestModel?
    private var updatedQuestions: [QuestionModel] = []
    public var question: QuestionModel?
    
    public var isNewQuestion: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayers()
        
        guard let id = test?.id else {
            return
        }
        
        DbManager.shared.getTestById(testId: id) { [weak self] (doc, error) in
            self?.test = doc
            self?.updatedQuestions = self?.test?.questions ?? []
        }
        
        answerCorrectTextView.layer.backgroundColor = UIColor(red: CGFloat(0.0), green: CGFloat(255.0), blue: CGFloat(0.0), alpha: CGFloat(0.5)).cgColor
        
        for textView in answersWrongTextViews {
            textView.layer.backgroundColor = UIColor.init(red: CGFloat(255.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(0.3)).cgColor
        }
        
        answersWrongTextViews.append(answerWrong1TextView)
        answersWrongTextViews.append(answerWrong2TextView)
        answersWrongTextViews.append(answerWrong3TextView)
        questionNameTextView.centerText()
        
        questionNameTextView.addToolbar()
        answerCorrectTextView.addToolbar()
        for textView in answersWrongTextViews {
            textView.addToolbar()
        }
        
        if isNewQuestion == false {
            loadQuestionToView()
            finishButton.isEnabled = false
            addQuestionButton.setTitle("Edytuj pytanie", for: .normal)
        } else {
            resetTextViews()
        }
        centerTextViewsContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        centerTextViewsContent()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func loadQuestionToView() {
        
        guard let question = question else {
            print("No question!")
            return
        }
        
        questionNameTextView.text = question.name
        var k = 0
        
        for answer in question.answers {
            if answer.isCorrect {
                answerCorrectTextView.text = answer.name
            } else {
                answersWrongTextViews[k].text = answer.name
                k = k + 1
            }
        }
    }
    
    private func setupLayers() {
        setupLayer(layer: questionNameTextView.layer)
        setupLayer(layer: answerCorrectTextView.layer)
        setupLayer(layer: answerWrong1TextView.layer)
        setupLayer(layer: answerWrong2TextView.layer)
        setupLayer(layer: answerWrong3TextView.layer)
    }
    
    private func setupLayer(layer: CALayer) {
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 10
        layer.masksToBounds = true
    }
    
    private func resetTextViews() {
        answerCorrectTextView.text = "Poprawna odpowiedź"
        for textView in answersWrongTextViews {
            textView.text = "Błędna odpowiedź"
        }
        questionNameTextView.text = "Wprowadź treść pytania"
    }
    
    private func centerTextViewsContent() {
        questionNameTextView.centerText()
        answerCorrectTextView.centerText()
        answerWrong1TextView.centerText()
        answerWrong2TextView.centerText()
        answerWrong3TextView.centerText()
    }
    
    private func updateTest(completion: @escaping (Bool?) -> Void) {
        guard let oldTest = test else {
            return
        }
        
        let updatedTest: TestModel = TestModel(id: oldTest.id, name: oldTest.name, category: oldTest.category, description: oldTest.description, difficultyLevel: oldTest.difficultyLevel, rating: oldTest.rating, ratingsCounter: oldTest.ratingsCounter, time: oldTest.time, popularity: oldTest.popularity, questions: updatedQuestions, owner: oldTest.owner)
        
        DbManager.shared.updateTest(test: updatedTest) { [weak self] (isSuccess) in
            if isSuccess {
                self?.test = updatedTest
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func isQuestionRepeated(questions: [QuestionModel], newQuestion: QuestionModel) -> Bool {
        var isRepeated = false
        for question in updatedQuestions {
            if question == newQuestion {
                isRepeated = true
                print("Same question exists!")
                break
            }
        }
        return isRepeated
    }
    
    // MARK: - @IBAction
    @IBAction func addQuestionButtonClicked(_ sender: Any) {
        let answers: [AnswerModel] = [AnswerModel(name: answerCorrectTextView.text, isCorrect: true),
                                      AnswerModel(name: answerWrong1TextView.text, isCorrect: false),
                                      AnswerModel(name: answerWrong2TextView.text, isCorrect: false),
                                      AnswerModel(name: answerWrong3TextView.text, isCorrect: false)]
        let newQuestion: QuestionModel = QuestionModel(name: questionNameTextView.text, answers: answers)
        
        if isNewQuestion == false {
            
            for question in updatedQuestions {
                print(question.name)
            }
            
//            for var question in updatedQuestions {
//                if question == newQuestion {
//                    question = newQuestion
//                    break
//                }
//            }
            let oldQuestion = question
            for (index, question) in updatedQuestions.enumerated() {
                if question == oldQuestion {
                    updatedQuestions[index] = newQuestion
                    break
                }
            }

            for question in updatedQuestions {
                print(question.name)
            }
            
            self.updateTest { [weak self] (isSuccess) in
                guard let success = isSuccess else {
                    return
                }
                
                if success {
                    let successHud = JGProgressHUD()
                    successHud.textLabel.text = "Dodano pytanie"
                    successHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    successHud.show(in: (self?.view)!, animated: true)
                    successHud.dismiss(afterDelay: 0.7)
                    self?.resetTextViews()
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    let successHud = JGProgressHUD()
                    successHud.textLabel.text = "Błąd dodawania"
                    successHud.indicatorView = JGProgressHUDErrorIndicatorView()
                    successHud.show(in: (self?.view)!, animated: true)
                    successHud.dismiss(afterDelay: 0.7)
                }
            }
            
            
        } else if isNewQuestion == true {
            if isQuestionRepeated(questions: updatedQuestions, newQuestion: newQuestion) == true {
                return
            }
            
            
            
            updatedQuestions.append(newQuestion)
            
            self.updateTest { [weak self] (isSuccess) in
                guard let success = isSuccess else {
                    return
                }
                
                if success {
                    let successHud = JGProgressHUD()
                    successHud.textLabel.text = "Dodano pytanie"
                    successHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    successHud.show(in: (self?.view)!, animated: true)
                    successHud.dismiss(afterDelay: 0.7)
                    self?.resetTextViews()
                } else {
                    let successHud = JGProgressHUD()
                    successHud.textLabel.text = "Błąd dodawania"
                    successHud.indicatorView = JGProgressHUDErrorIndicatorView()
                    successHud.show(in: (self?.view)!, animated: true)
                    successHud.dismiss(afterDelay: 0.7)
                }
            }
        }
    }
    
    @IBAction func finishButtonClicked(_ sender: Any) {
        //        self.updateTest { [weak self] (isSuccess) in
        //            if let bool = isSuccess, bool {
        //                self?.navigationController?.popViewController(animated: true)
        //            } else {
        //                self?.navigationController?.popViewController(animated: true)
        //            }
        //        }
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TextViewDelegate
extension AddQuestionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        centerTextViewsContent()
    }
}
