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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("It's TestsByCategory View Controller now")
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension TestsByCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = testsByCategoryTableView.dequeueReusableCell(withIdentifier: "testsByCatCell", for: indexPath) as! SearchTestCell
        
        return cell
    }
    
    
}
