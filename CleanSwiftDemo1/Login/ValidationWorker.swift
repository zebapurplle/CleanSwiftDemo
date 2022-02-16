//
//  ValidationWorker.swift
//  CleanSwiftDemo1
//
//  Created by zeba on 27/11/19.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class ValidationWorker {
    
    typealias successHandler = (_ success:Bool, _ meesage: String)->Void
    
    func validateLoginRequest(request: Login.User.Request, completionHandler: @escaping successHandler) {
        
        var isSuccess = false
        var message = "Please enter valid username and password"
        if request.loginInfo.userName != "", request.loginInfo.password != "" {
            isSuccess = true
            message = ""
        }
        completionHandler(isSuccess,message)
    }
}