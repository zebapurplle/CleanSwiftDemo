//
//  LoginWorker.swift
//  CleanSwiftDemo1
//
//  Created by zeba on 26/11/19.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class LoginWorker
{
    typealias SuccessHandler = (_ loginResp:LoginResponse?)->Void
    
    /// Call login API
    func login(email: String, password: String, completionHandler: @escaping SuccessHandler)
    {
        Login.url = "https://restful-booker.herokuapp.com/auth"
        Login.params = ["username" : email,"password" : password]
        Login.httpMethod = .post
        
        Login.callWedSercice(apiWrapper: Login.apiWrapper()) { response, model in
            switch response {
            case .success:
                completionHandler(model)
            case .error:
                completionHandler(nil)
            }
        }
    }
}
