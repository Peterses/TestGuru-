//
//  TextView+extension.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 31/10/2020.
//

import Foundation
import UIKit

extension UITextView {
    
    func centerText() {
        self.textAlignment = .center
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
