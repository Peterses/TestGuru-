//
//  TestTableViewCell.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 19/10/2020.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
