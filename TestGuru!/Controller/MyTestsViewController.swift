//
//  MyTestsViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 19/10/2020.
//

import UIKit
import JGProgressHUD

protocol ShowAlert {
    func showErrorAlert()
}

class MyTestsViewController: UIViewController {

    @IBOutlet weak var myTestsTableView: UITableView!
    @IBOutlet weak var createTestButton: UIButton!
    
    private var tests: [TestModel] = []

    var alertDelegate: ShowAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertDelegate = self
        myTestsTableView.delegate = self
        myTestsTableView.dataSource = self
    }
    
    private func loadTestsToView() {
        DbManager.shared.getUserTests { (tests, error) in
            if let error = error {
                print(error)
            } else {
                
                guard let tests = tests else {
                    return
                }
                
                self.tests = tests
                DispatchQueue.main.async {
                    self.myTestsTableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        myTestsTableView.deselectSelectedRow(animated: true)
        
        let disclosure = UITableViewCell()
        disclosure.frame = createTestButton.bounds
        disclosure.accessoryType = .disclosureIndicator
        disclosure.isUserInteractionEnabled = false
        createTestButton.addSubview(disclosure)
        
        createTestButton.addTopBorderWithColor(color: UIColor.white, width: 0.3)
        createTestButton.addBottomBorderWithColor(color: UIColor.white, width: 0.3)
        loadTestsToView()
    }
    
    private func deleteFromDatabase(testId: String?) {
        guard let id = testId else {
            alertDelegate?.showErrorAlert()
            return
        }
        
        DbManager.shared.deleteTest(testId: id) { [weak self] (isSuccess) in
            if let success = isSuccess, success {
                print("test deleted")
            } else {
                self?.alertDelegate?.showErrorAlert()
            }
        }
    }
    
    private func swipeDeleteAction(at: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Usuń") { [weak self] (action, view, completion) in
            if let testId = self?.tests[at.row].id {
                self?.tests.remove(at: at.row)
                self?.myTestsTableView.deleteRows(at: [at], with: .fade)
                self?.deleteFromDatabase(testId: testId)
                let successHud = JGProgressHUD()
                successHud.textLabel.text = "Usunięto"
                successHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                successHud.show(in: (self?.view)!, animated: true)
                successHud.dismiss(afterDelay: 0.5)
                completion(true)
            }
        }
        action.backgroundColor = .red
        return action
    }
    
    private func swipeEditAction(at: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edytuj") { [weak self] (action, view, completion) in
            completion(true)
            self?.performSegue(withIdentifier: Constants.editTestSegue, sender: self?.tests[at.row])
        }
        action.backgroundColor = .systemBlue
        return action
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showMyTestInfo {
            let vc = segue.destination as? TestInfoViewController
            vc?.test = sender as? TestModel
        } else if segue.identifier == Constants.editTestSegue {
            let vc = segue.destination as? EditTestViewController
            vc?.test = sender as? TestModel
        }
    }
    
}

// MARK: - TableViewDelegate
extension MyTestsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTestsTableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! TestTableViewCell
        cell.nameLabel.text = tests[indexPath.row].name
        
        var category2: CategoryModel?
        
        DbManager.shared.getCategoryByName(name: tests[indexPath.row].category) { (category, isSuccess) in

            if isSuccess == true {
                
                guard let category = category else {
                    return
                }
                
                category2 = CategoryModel.init(name: category.name, icon: category.icon, image: category.image)
                
                cell.iconLabel.text = category2?.icon
            } else {
                print("error")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = swipeDeleteAction(at: indexPath)
        let edit = swipeEditAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showMyTestInfo, sender: tests[indexPath.row])
    }
}

// MARK: - ShowAlert
extension MyTestsViewController: ShowAlert {
    func showErrorAlert() {
        // TODO: - show alert
        print("alert showed from protocol")
    }
}
