//
//  TestCollectionViewCell.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 14/10/2020.
//

import UIKit
import Cosmos

class TestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var starRatingView: CosmosView!
    
    func configure(title: String, category: String, time: String, rating: Double, imageUrl: String) {
        self.imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        backView.layer.cornerRadius = 25
        imageView.image = UIImage(named: imageUrl)
        categoryLabel.text = category
        timeLabel.text = time + " min"
        titleLabel.text = title
        starRatingView.rating = rating
        starRatingView.settings.updateOnTouch = false
    }
}
