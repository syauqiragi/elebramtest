//
//  UserDefaultHelper.swift
//  DoubleGate
//
//  Created by Ahmad Syauqi Albana on 29/08/20.
//  Copyright © 2020 Ahmad Syauqi Albana. All rights reserved.
//

import Foundation

struct Session {
    static func set(value: Any, key: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
    }
    
    static func remove(key: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
    }
    
    static func getString(key: String) -> String {
        return (UserDefaults.standard.value(forKey: key) as? String) ?? ""
    }
    
    static func getInt(key: String) -> Int {
        return (UserDefaults.standard.value(forKey: key) as? Int) ?? 0
    }
    
    static func getBool(key: String) -> Bool {
        return (UserDefaults.standard.value(forKey: key) as? Bool) ?? false
    }

    static func setLogin() {
        set(value: true, key: "login")
    }
    
    static func setToken(token: String) {
        set(value: token, key: "token")
    }
    
    static func setLogout() {
        remove(key: "login")
        remove(key: "token")
    }
    
    static func getToken() -> String {
        return (UserDefaults.standard.value(forKey: "token") as? String) ?? ""
    }

    static func checkLogin() -> Bool {
        return getBool(key: "login") && !getString(key: "token").isEmpty
    }
}
