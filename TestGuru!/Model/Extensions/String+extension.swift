//
//  String+extension.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 12/10/2020.
//

import Foundation

extension String {
    func firstUppercased() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
