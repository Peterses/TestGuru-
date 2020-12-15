//
//  MenuViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 12/10/2020.
//

import UIKit

final class MenuViewController: UIViewController {

    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var testSearchBar: UISearchBar!
    @IBOutlet weak var testsCollectionView: UICollectionView!
    @IBOutlet weak var popularView: UIView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchTestsTableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    private let categoriesTableViewTag = 1
    private let testsTableViewTag = 2
    
    private var effect: UIVisualEffect!
    private var categories: [CategoryModel] = []
    private let activityIndicatorViewTag = 666
    private var popularTests: [TestModel] = []
    private var filteredData: [TestModel] = []
    private var categoriesInfo: [CategoryModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        categoriesTableView.deselectSelectedRow(animated: true)
        searchTestsTableView.deselectSelectedRow(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllTests { (isSuccess) in
//            self.filteredData = self.popularTests
        }
        testSearchBar.searchBarStyle = .minimal
        blurEffectView.isHidden = true
        searchBarView.isHidden = true
        effect = blurEffectView.effect
        blurEffectView.effect = nil
        setupDelegates()
        getAllCategories()
        filteredData = popularTests
        searchTestsTableView.backgroundColor = UIColor.clear
        categoriesTableView.backgroundColor = UIColor.clear
        
        let searchField = testSearchBar.value(forKey: "searchField") as? UITextField
        searchField?.textColor = UIColor.white
        
        let attributedString = NSAttributedString(string: "Wyszukaj test", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: CGFloat(0.5))])
        searchField!.attributedPlaceholder = attributedString
        if let colViewLayout = testsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            colViewLayout.itemSize = CGSize(width: popularView.frame.width - 20,
                                            height: popularView.frame.height - 60)
        }
    }
    
    private func getAllTests(completion: @escaping (Bool) -> Void) {
        DbManager.shared.getAllTests { (tests, isSuccess) in
            self.popularTests = tests!
        }
    }
    
    private func getPopularTests(howMany: Int, completion: @escaping (Bool) -> Void) {
        DbManager.shared.getPopularTests(limit: howMany) { [weak self] (tests, isSuccess) in
            if isSuccess {
                guard let popularTests = tests else {
                    print("EE")
                    return
                }
                
                self?.popularTests = popularTests
                completion(true)
                
            } else {
                print("Error")
                completion(false)
            }
        }
    }
    
    private func setupDelegates() {
        self.categoriesTableView.delegate = self
        self.categoriesTableView.dataSource = self
        self.testSearchBar.delegate = self
        getPopularTests(howMany: 3) { (isSuccess) in
            if isSuccess {
                self.testsCollectionView.delegate = self
                self.testsCollectionView.dataSource = self
            }
        }
        self.searchTestsTableView.delegate = self
        self.searchTestsTableView.dataSource = self
    }
    
    private func getAllCategories() {
        showActivityIndicator()
        DbManager.shared.getAllCategories { [weak self] (categories, isSuccess) in
            guard let me = self else {
                return
            }
            
            if let success = isSuccess, success {
                me.hideActivityIndicator()
                me.categories = categories ?? []
                me.categoriesTableView.reloadData()
            } else {
                print("We have unexpected error here!")
                me.hideActivityIndicator()
            }
        }
    }
    
    private func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.tag = activityIndicatorViewTag
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    private func hideActivityIndicator() {
        guard let activityIndicator = view.viewWithTag(activityIndicatorViewTag) as? UIActivityIndicatorView else {
            print("We have a problem here! activity indicator not exist!")
            return
        }
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showTestInfo {
            let vc = segue.destination as? TestInfoViewController
            vc?.test = sender as? TestModel
        } else if segue.identifier == Constants.showTestsByCategory {
            let vc = segue.destination as? TestsByCategoryViewController
            vc?.categoryName = sender as! String
        }
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        DbManager.shared.signOutUser { (isSuccess, message) in
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: ErrorsDescription.error, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: SuccessDescription.ok, style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - TableViewDelegate, TableViewDataSource
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case categoriesTableViewTag:
            return categories.count
        case testsTableViewTag:
            return filteredData.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case categoriesTableViewTag:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.categorieCell, for: indexPath) as? CategorieTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = categories[indexPath.row].name
            cell.iconLabel.text = categories[indexPath.row].icon
            cell.backgroundColor = UIColor.clear

            return cell
        case testsTableViewTag:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestCollectionCellSearch", for: indexPath) as? SearchTestCell else {
                return UITableViewCell()
            }
            cell.configure(test: filteredData[indexPath.row])
            cell.backgroundColor = UIColor.clear
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case categoriesTableViewTag:
            performSegue(withIdentifier: Constants.showTestsByCategory, sender: categories[indexPath.row].name)
        case testsTableViewTag:
            performSegue(withIdentifier: Constants.showTestInfo, sender: popularTests[indexPath.row])
        default:
            return
        }
    }
}

// MARK: - SearchBarDelegate
extension MenuViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.effect = self.effect
            self.blurEffectView.isHidden = false
        } completion: { (finished) in
            self.searchBarView.isHidden = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.alpha = 0.0
            self.blurEffectView.effect = nil
        } completion: { (finished) in
            self.blurEffectView.isHidden = true
            self.blurEffectView.alpha = 1.0
            searchBar.endEditing(true)
            self.searchBarView.isHidden = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = popularTests
        } else {
            
            for test in popularTests {
                if test.name.lowercased().contains(searchText.lowercased()) ||
                    test.difficultyLevel.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(test)
                }
            }
        }
        self.searchTestsTableView.reloadData()
    }
}

// MARK: - CollectionViewDelegate
extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return popularTests.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("collection delegate")
        guard let cell = testsCollectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionCell", for: indexPath) as? TestCollectionViewCell else {
            print("DEV: We have a problem here!")
            return UICollectionViewCell()
        }
        DbManager.shared.getCategoryByName(name: popularTests[indexPath.row].category) { [weak self] (category, isSuccess) in
            if isSuccess == true {
                guard let category = category else {
                    return
                }
                let category2 = CategoryModel(name: category.name, icon: category.icon, image: category.image)
                
                guard let name = self?.popularTests[indexPath.row].name, let time = self?.popularTests[indexPath.row].time, let rating = self?.popularTests[indexPath.row].rating else {
                    return
                }
                cell.configure(title: name, category: category2.name, time: String(time), rating: rating, imageUrl: category2.image)
            } else {
                print("error")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showTestInfo, sender: popularTests[indexPath.row])
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var heightPadding: CGFloat = 8
        
        switch view.frame.height {
        case 0...568:
            heightPadding += 0
        case 569...799:
            heightPadding += 35
        case 800...900:
            heightPadding += 50
        case 901...1200:
            heightPadding += 70
        default:
            break
        }
        
        return CGSize(width: (popularView.frame.width - 100),
                      height: (collectionView.frame.height - heightPadding))
    }
}
