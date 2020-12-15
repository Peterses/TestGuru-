//
//  TableView+deselect.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 03/11/2020.
//

import UIKit

extension UITableView {

    func deselectSelectedRow(animated: Bool)
    {
        if let indexPathForSelectedRow = self.indexPathForSelectedRow {
            self.deselectRow(at: indexPathForSelectedRow, animated: animated)
        }
    }

}
