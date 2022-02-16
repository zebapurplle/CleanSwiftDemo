//
//  LoginModels.swift
//  CleanSwiftDemo1
//
//  Created by zeba on 26/11/19.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Login {
    
    // MARK: - Use cases
    struct LoginInfo {
        var userName : String
        var password : String
    }
    
    enum User {
        
        struct Request {
            var loginInfo : LoginInfo
        }
        
        struct Response {
            var succes : Bool
            var message: String?
        }
        
        struct ViewModel {
            var isSuccess : Bool
            var message: String?
        }
    }
}
