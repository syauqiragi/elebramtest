//
//  UserModel.swift
//  elebramtest
//
//  Created by Ahmad Syauqi Albana on 20/07/22.
//
import SwiftyJSON

struct UserModel {

    let data: Data?
    let support: Support?

    init(_ json: JSON) {
        data = Data(json["data"])
        support = Support(json["support"])
    }
    
    struct Data {

        let id: Int?
        let email: String?
        let firstName: String?
        let lastName: String?
        let avatar: String?

        init(_ json: JSON) {
            id = json["id"].intValue
            email = json["email"].stringValue
            firstName = json["first_name"].stringValue
            lastName = json["last_name"].stringValue
            avatar = json["avatar"].stringValue
        }
    }
    
    struct Support {

        let url: String?
        let text: String?

        init(_ json: JSON) {
            url = json["url"].stringValue
            text = json["text"].stringValue
        }

    }
}
