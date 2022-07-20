//
//  ProfileVM.swift
//  elebramtest
//
//  Created by Ahmad Syauqi Albana on 20/07/22.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa

class ProfileVM {
    var user = BehaviorRelay<UserModel?>(value: nil)
    var error = BehaviorRelay<String?>(value: nil)
    
    func getProfile() {
        let url = ApiCollection.profile()
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                guard let self = self else {
                    return
                }
                print(url, "=", response.response?.statusCode ?? "", response.result)
                guard let res = response.value else { return }
                let jsonResult = JSON(res)
                switch response.result{
                case .success( _):
                    switch response.response?.statusCode{
                    case 200?:
                        let data = UserModel(jsonResult)
                        self.user.accept(data)
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
