//
//  TestsByCategory.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 17/10/2020.
//

import Foundation
import UIKit

class TestsByCategoryViewController: UIViewController {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var testsByCategoryTableView: UITableView!
    
    public var categoryName = ""
    private var tests: [TestModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cat = Category(name: categoryName)
        categoryNameLabel.text = cat.name + " " + cat.icon
        testsByCategoryTableView.delegate = self
        testsByCategoryTableView.dataSource = self
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTests()
    }
    
    private func loadTests() {
        DbManager.shared.getTestsByCategory(category: categoryName) { (tests, err) in
            self.tests = tests ?? []
            DispatchQueue.main.async {
                self.testsByCategoryTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let test = sender as? TestModel {
            if segue.identifier == Constants.showTestInfo {
                let vc = segue.destination as? TestInfoViewController
                vc?.test = test
            }
        }
    }
}

// MARK: - TableViewDelegate
extension TestsByCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = testsByCategoryTableView.dequeueReusableCell(withIdentifier: "TestsByCategoryCell", for: indexPath) as! SearchTestCell
        cell.configure(test: tests[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showTestInfo, sender: tests[indexPath.row])
        tableView.deselectSelectedRow(animated: true)
        //print(tests[indexPath.row].id)
    }
}
