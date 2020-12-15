//
//  AfterTestViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 06/11/2020.
//

import UIKit
import MBCircularProgressBar
import Cosmos

class AfterTestViewController: UIViewController {
    
    @IBOutlet weak var pointsResultLabel: UILabel!
    @IBOutlet weak var percentageResultView: MBCircularProgressBarView!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var returnToMenuButton: UIButton!
    
    public var test: TestModel?
    public var result: Double?
    public var pointsResult: Int?
    
    override func viewDidAppear(_ animated: Bool) {
        setResultToView()
        updateUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.percentageResultView.value = 0
    }
    
    private func updateUserStats() {
        let currentUser = DbManager.shared.getCurrentUser()
        guard let signedUser = currentUser, let categoryName = test?.category, let points = pointsResult, let totalPoints = test?.questions.count else {
            return
        }
        print(signedUser)
        print(categoryName)
        print(points)
        print(totalPoints-points)
        DbManager.shared.updateStats(user: signedUser, categoryName: categoryName, goodAnswers: points, badAnswers: totalPoints - points) { (isSuccess) in
            if isSuccess {
                print("OK")
            } else {
                print("bad")
            }
        }
    }
    
    private func setResultToView() {
        guard let points = pointsResult, let totalPoints = test?.questions.count else {
            return
        }
        
        pointsResultLabel.text = "\(points)/\(totalPoints)"
        
        UIView.animate(withDuration: 3) {
            self.percentageResultView.value = CGFloat(self.result!)
        }
    }
    
    // MARK: - @IBAction
    @IBAction func returnToMenuButtonClicked(_ sender: Any) {
        guard let rating = starRatingView?.rating, rating != 0.0, let testId = test?.id else {
            performSegue(withIdentifier: Constants.showMenu, sender: self)
            return
        }
        
        DbManager.shared.updateTestRating(testId: testId, rating: rating) { (isSuccess) in
            if(isSuccess) {
                print("OK")
                self.performSegue(withIdentifier: Constants.showMenu, sender: self)
            } else {
                print("BAD")
                self.performSegue(withIdentifier: Constants.showMenu, sender: self)
            }
        }
    }
}
