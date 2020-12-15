//
//  SearchTestCell.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 13/10/2020.
//

import UIKit
import Cosmos

class SearchTestCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var difficultyLevelLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var starRatingCosmosView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.starRatingCosmosView.settings.updateOnTouch = false
        self.starRatingCosmosView.settings.fillMode = .half
    }
    
    public func configure(test: TestModel) {
        self.titleLabel.text = test.name
        self.difficultyLevelLabel.text = test.difficultyLevel
        self.timeLabel.text = "Czas: " + String(test.time) + " min"
        self.starRatingCosmosView.rating = test.rating
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
