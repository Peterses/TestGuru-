//
//  SearchTestViewController.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 13/10/2020.
//

import UIKit

class SearchTestViewController: UIViewController {

    private let tests = ["Dodawanie - klasa 3", "Odejmowanie - klasa 7", "Historia Rzymu"]
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var testsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testsTableView.delegate = self
        self.testsTableView.dataSource = self
        self.testsTableView.delegate = self
    }
}

extension SearchTestViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = testsTableView.dequeueReusableCell(withIdentifier: "searchTestCell", for: indexPath) as! SearchTestCell
        
        cell.titleLabel.text = tests[indexPath.row]
        return cell
    }
    
}

extension SearchTestViewController: UISearchBarDelegate {
    
}

