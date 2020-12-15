//
//  TestInfoVC.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 18/10/2020.
//

import UIKit

class TestInfoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var difficultyLevelLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startTestButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var numberOfQuestions: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var questionsView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    //private let category: CategoryModel = Mock.shared.categories[0]
    public var test: TestModel?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayers()
        loadTestInfo()
    }
    
    private func setUpLayers() {
        setUpLayer(layer: infoView.layer)
        setUpLayer(layer: timeView.layer)
        setUpLayer(layer: questionsView.layer)
        setUpLayer(layer: startTestButton.layer)
    }

    private func setUpLayer(layer: CALayer) {
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 10
    }
    
    private func loadTestInfo() {
        guard let name = test?.name, let category = test?.category, let description = test?.description, let difficultyLevel = test?.difficultyLevel, let time = test?.time, let questionsCount = test?.questions.count else {
            return
        }
        var categoryImageUrl = ""
        DbManager.shared.getCategoryByName(name: category) { (category, isSuccess) in
            print(category)
            if let categoryImage = category?.image {
                categoryImageUrl = categoryImage
            }
            self.categoryImageView.image = UIImage(named: categoryImageUrl)
        }
        
        nameLabel.text = name
        categoryLabel.text = category
        descriptionLabel.text = description
        difficultyLevelLabel.text = difficultyLevel
        timeLabel.text = "\(time) min"
        numberOfQuestions.text = String(questionsCount)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showDuringTestSegue {
            let vc = segue.destination as? DuringTestViewController
            vc?.test = sender as? TestModel
        }
    }
    
    @IBAction func startTestButtonClicked(_ sender: Any) {
        
        guard let questionsNumber = test?.questions.count, questionsNumber > 0 else {
            let alert = UIAlertController(title: ErrorsDescription.error, message: ErrorsDescription.testWithoutQuestions, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: SuccessDescription.ok, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        performSegue(withIdentifier: Constants.showDuringTestSegue, sender: test)
    }
}
