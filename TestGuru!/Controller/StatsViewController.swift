//
//  StatsViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 16/10/2020.
//

import Foundation
import UIKit
import Charts
import MBCircularProgressBar

class StatViewController: UIViewController {
    
    @IBOutlet weak var categoryPieChart: PieChartView!
    @IBOutlet weak var averageTestResultProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var solvedTestsLabel: UILabel!
    @IBOutlet weak var createdTestsLabel: UILabel!
    @IBOutlet weak var averageResultView: UIView!
    @IBOutlet weak var favouriteCategoryView: UIView!
    @IBOutlet weak var createdTestsView: UIView!
    @IBOutlet weak var solvedTestsView: UIView!
    
    private var userStats: StatsModel?
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserStats { (isSuccess) in
            if isSuccess {
                self.setupPieChart()
                self.setupOtherInfo()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupLayers()
    }
    
    private func loadUserStats(completion: @escaping (Bool) -> Void) {
        guard let user = DbManager.shared.getCurrentUser() else {
            return
        }
        print(user.email)
        DbManager.shared.getUserStats(user: user) { (statsModel, error) in
//            if let stats = statsModel, error == nil {
                self.userStats = statsModel
                completion(true)
//            }
        }
    }
    
    private func calculateAverageScore() -> Double? {
        guard let categories = userStats?.statsByCategory else {
            return nil
        }
        var pointsSum = 0;
        var allPoints = 0;
        for category in categories {
            pointsSum += category.allGoodAnswers
            allPoints += category.allGoodAnswers + category.allBadAnswers
        }
        
        return Double(pointsSum) / Double(allPoints) * 100.0
    }
    
    private func checkFavouriteCategory() -> String? {
        guard let categories = userStats?.statsByCategory else {
            return nil
        }
        var categoryImage = ""
        var max = 0
        for category in categories {
            if category.testsCompleted > max {
                max = category.testsCompleted
                categoryImage = category.categoryName
            }
        }
        return categoryImage
    }
    
    private func setupOtherInfo() {
        guard let testsCompleted = userStats?.allTestsCompleted else {
            return
        }
        solvedTestsLabel.text = String(testsCompleted)
        guard let score = calculateAverageScore() else {
            return
        }
        UIView.animate(withDuration: 3.0) {
            self.averageTestResultProgressBar.value = CGFloat(score)
        }
        
        guard let favouriteCategory = checkFavouriteCategory() else {
            return
        }
        
        DbManager.shared.getCategoryByName(name: favouriteCategory) { (category, isSuccess) in
            if isSuccess {
                guard let image = category?.image else {
                    return
                }
                self.categoryImage.image = UIImage(named: image)
            }
        }
    }
    
    private func setupPieChart() {
        categoryPieChart.chartDescription?.enabled = false
        categoryPieChart.drawHoleEnabled = false
        categoryPieChart.rotationAngle = 0
        categoryPieChart.isUserInteractionEnabled = false
        
        var entries: [PieChartDataEntry] = []
        
        guard let categories = userStats?.statsByCategory else {
            return
        }
        for category in categories {
            if category.testsCompleted > 0 {
                entries.append(PieChartDataEntry(value: Double(category.testsCompleted), label: category.categoryName))
            }
        }
        let dataSet = PieChartDataSet(entries: entries, label: "")
        let c1 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: CGFloat(0.5))
        let c2 = UIColor(red: CGFloat(255.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(0.5))
        let c3 = UIColor(red: CGFloat(0.0), green: CGFloat(255.0), blue: CGFloat(0.0), alpha: CGFloat(0.5))
        let c4 = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(255.0), alpha: CGFloat(0.5))
        let c5 = UIColor(red: CGFloat(255.0), green: CGFloat(255.0), blue: CGFloat(0.0), alpha: CGFloat(0.5))
        let c6 = UIColor(red: CGFloat(100.0), green: CGFloat(125.0), blue: CGFloat(0.0), alpha: CGFloat(0.5))
        let c7 = UIColor(red: CGFloat(123.0), green: CGFloat(200.0), blue: CGFloat(50.0), alpha: CGFloat(0.5))
        
        dataSet.colors = [c1, c2, c3, c4, c5, c6, c7]
        dataSet.drawValuesEnabled = false
        
        categoryPieChart.data = PieChartData(dataSet: dataSet)
    }
    
    private func setupLayers() {
        setupLayer(layer: averageResultView.layer)
        setupLayer(layer: solvedTestsView.layer)
        setupLayer(layer: createdTestsView.layer)
        setupLayer(layer: favouriteCategoryView.layer)
    }
    
    private func setupLayer(layer: CALayer) {
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 10
    }
}
