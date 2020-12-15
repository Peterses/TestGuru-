//
//  UserModel.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 15/10/2020.
//

import Foundation

struct UserModel: Codable {

    let email: String
    //let password: String
    
    init(email: String) {
        self.email = email
        //self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case email
       // case password
    }
}
