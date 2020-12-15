//
//  AddQuestionsViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 30/10/2020.
//

import UIKit
import JGProgressHUD

class AddQuestionsViewController: UIViewController {
    
    @IBOutlet weak var addQuestionButton: UIButton!
    @IBOutlet weak var questionsTableView: UITableView!
    
    public var test: TestModel?
    private var questions: [QuestionModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        questionsTableView.deselectSelectedRow(animated: true)
        
        guard let testId = test?.id else {
            return
        }
        
        DbManager.shared.getTestById(testId: testId) { [weak self] (test, error) in
            self?.test = test
            
            guard let questions = self?.test?.questions else {
                return
            }
            
            self?.questions = questions
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.questionsTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AddQuestionViewController
        let test = self.test
        if segue.identifier == "AddQuestionSegue" {
            if (sender != nil) {
                vc?.isNewQuestion = false
                vc?.question = sender as? QuestionModel
                vc?.test = test
            } else {
                vc?.isNewQuestion = true
                vc?.test = test
            }
        }
    }
    
    private func deleteQuestionFromDatabase(test: TestModel, newQuestions: [QuestionModel], completion: @escaping (Bool) -> Void) {
        
        let newTest: TestModel = TestModel(id: test.id, name: test.name, category: test.category, description: test.description, difficultyLevel: test.difficultyLevel, rating: test.rating, ratingsCounter: test.ratingsCounter, time: test.time, popularity: test.popularity, questions: newQuestions, owner: test.owner)
        
        DbManager.shared.updateTest(test: newTest) { (isSuccess) in
            if isSuccess {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func swipeDeleteAction(at: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Usuń") { [weak self] (action, view, completion) in
            let question = self?.questions[at.row]
            self?.questions.remove(at: at.row)
            self?.questionsTableView.deleteRows(at: [at], with: .fade)
            
            if let test = self?.test, let newQuestions = self?.questions {
                self?.deleteQuestionFromDatabase(test: test, newQuestions: newQuestions, completion: { (isSuccess) in
                    if isSuccess {
                        let successHud = JGProgressHUD()
                        successHud.textLabel.text = "Usunięto"
                        successHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        successHud.show(in: (self?.view)!, animated: true)
                        successHud.dismiss(afterDelay: 0.5)
                    } else {
                        let errorHud = JGProgressHUD()
                        errorHud.textLabel.text = "Błąd usuwania"
                        errorHud.indicatorView = JGProgressHUDErrorIndicatorView()
                        errorHud.show(in: (self?.view)!, animated: true)
                        errorHud.dismiss(afterDelay: 0.5)
                        self?.questions.insert(question!, at: at.row)
                        self?.questionsTableView.insertRows(at: [at], with: .automatic)
                    }
                })
            }
            completion(true)
        }
        action.backgroundColor = .red
        return action
    }
    
    @IBAction func addNewQuestionButton(_ sender: Any) {
        performSegue(withIdentifier: "AddQuestionSegue", sender: nil)
    }
}

// MARK: - TableViewDelegate
extension AddQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = questionsTableView.dequeueReusableCell(withIdentifier: "QuestionCellIdentifier", for: indexPath) as! QuestionCell
        
        cell.questionNameLabel.text = questions[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = swipeDeleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = questions[indexPath.row]
        
        performSegue(withIdentifier: "AddQuestionSegue", sender: question)
    }
}

extension AddQuestionViewController: ShowAlert {
    func showErrorAlert() {
       
    }
}
