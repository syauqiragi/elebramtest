//
//  LoginVM.swift
//  HR
//
//  Created by Ahmad Syauqi Albana on 13/11/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa

class LoginVM {
    var token = BehaviorRelay<String?>(value: nil)
    var error = BehaviorRelay<String?>(value: nil)
    
    func performLogin(email: String = "", password: String = "") {
        let param: Parameters = [
            "email": email,
            "password": password
        ]
        let url = ApiCollection.login()
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                guard let self = self else {
                    return
                }
                print(url, param, "=", response.response?.statusCode ?? "", response.result)
                guard let res = response.value else { return }
                let jsonResult = JSON(res)
                switch response.result{
                case .success( _):
                    switch response.response?.statusCode{
                    case 200?:
                        let data = jsonResult["token"].stringValue
                        self.token.accept(data)
                    default:
                        let errorData = jsonResult["error"].stringValue
                        self.error.accept(errorData)
                    }
                case .failure(let error) :
                    self.error.accept(error.localizedDescription)
                }
        }
    }
}
