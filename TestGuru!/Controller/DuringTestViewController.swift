//
//  DuringTestViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 18/10/2020.
//

import UIKit
import AudioToolbox

class DuringTestViewController: UIViewController {
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var testProgressView: UIProgressView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    private var answerButtons: [UIButton] = []
    public var test: TestModel? = nil
    private var MAX: Int = 0
    private var questionId = 0
    private let correctAnswerTag = 1
    private var result = 0.0
    private var pointsResult = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerButtons.append(answerButton1)
        answerButtons.append(answerButton2)
        answerButtons.append(answerButton3)
        answerButtons.append(answerButton4)
        setupAnswerButton()
        MAX = test?.questions.count ?? 0
        loadQuestion(id: questionId)
        
        setUpLayer()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setUpLayer() {
        questionTitleLabel.layer.masksToBounds = true
        questionTitleLabel.layer.cornerRadius = 15
        questionTitleLabel.layer.shadowColor = UIColor.white.cgColor
        questionTitleLabel.layer.shadowOffset = .zero
        questionTitleLabel.layer.shadowOpacity = 0.6
        questionTitleLabel.layer.shadowRadius = 10
        questionTitleLabel.layer.shadowPath = UIBezierPath(rect: questionTitleLabel.bounds).cgPath
        
        nextQuestionButton.layer.cornerRadius = 15
        
        for button in answerButtons {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 15
            button.layer.shadowColor = UIColor.white.cgColor
            button.layer.shadowOffset = .zero
            button.layer.shadowOpacity = 0.6
            button.layer.shadowRadius = 10
            button.layer.shadowPath = UIBezierPath(rect: button.bounds).cgPath
        }
    }
    
    private func updateResult() {
        result += 1.0
        pointsResult += 1
    }
    
    private func setupAnswerButton() {
        for button in answerButtons {
            button.titleLabel?.lineBreakMode = NSLineBreakMode(rawValue: 0)!
            button.titleLabel?.textAlignment = .center
        }
    }
    
    private func loadQuestion(id: Int) {
        setDefaultAnswerButtonsTags()
        updateProgressView()
        
        questionTitleLabel.text = test?.questions[id].name
        nextQuestionButton.isEnabled = false
        
        var answersRand = test?.questions[questionId].answers
        
        var i = 0
        while i < 4 {
            guard let index = answersRand!.indices.randomElement() else {
                print("DEV: Incorrect index randomisation!")
                return
            }
            let answer: AnswerModel = answersRand![index]
            answerButtons[i].setTitle(answer.name, for: .normal)
            answerButtons[i].setAttributedTitle(NSAttributedString(string: answer.name), for: .normal)
            answersRand!.remove(at: index)
            if answer.isCorrect {
                answerButtons[i].tag = 1
            }
            i = i + 1
        }
    }
    
    private func updateProgressView() {
        var progress: Float = Float(questionId + 1)
        progress = progress/Float(MAX)
        DispatchQueue.main.async {
            self.testProgressView.setProgress(progress, animated: true)
        }
    }
    
    private func setDefaultAnswerButtonsTags() {
        for button in answerButtons {
            button.tag = 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let test = sender as? TestModel {
            if segue.identifier == Constants.afterTestSegue {
                let vc = segue.destination as? AfterTestViewController
                vc?.test = test
                result = (result/Double(MAX)) * 100
                vc?.result = result
                vc?.pointsResult = pointsResult
            }
        }
    }
    
    //MARK: - @IBAction
    @IBAction func answerButtonClicked(_ sender: UIButton) {
        
        nextQuestionButton.isEnabled = true
        
        for button in answerButtons {
            if button != sender {
                button.isEnabled = false
                button.isHighlighted = true
            }
        }
        
        if sender.tag == correctAnswerTag {
            sender.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.5)
            sender.layer.opacity = 1
            updateResult()
            
        } else {
            sender.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.5)
            sender.layer.opacity = 1

            for button in answerButtons {
                if button.tag == correctAnswerTag {
                    button.layer.borderWidth = 4
                    button.layer.borderColor = UIColor.green.cgColor
                }
            }
            // Vibration on bad answer clicked
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
    
    @IBAction func nextQuestionButtonClicked(_ sender: Any) {
        for button in answerButtons {
            button.layer.borderWidth = 0
            button.layer.opacity = 0.75
            button.backgroundColor = UIColor(red: 237, green: 245, blue: 255, alpha: 1)
            
            button.isEnabled = true
            button.isHighlighted = false
            
        }

        questionId = questionId + 1
        if (((test?.questions.endIndex)! - 1) == questionId) {
            self.nextQuestionButton.setTitle("Zakończ test", for: .normal)
            loadQuestion(id: questionId)
        } else if (test?.questions.endIndex == questionId){
            performSegue(withIdentifier: Constants.afterTestSegue, sender: test)
        } else {
            loadQuestion(id: questionId)
        }
    }
}
