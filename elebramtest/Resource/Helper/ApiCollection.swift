//
//  ApiCollection.swift
//  AHA
//
//  Created by Mamikos on 14/05/20.
//  Copyright © 2020 Ahmad Syauqi Albana. All rights reserved.
//

import Foundation
import Alamofire

struct ApiCollection {
    static let base = "https://reqres.in/api"
    
    static func login() -> String {
        return "\(base)/login"
    }
    
    static func profile() -> String {
        return "\(base)/users/2"
    }
    
    
}
