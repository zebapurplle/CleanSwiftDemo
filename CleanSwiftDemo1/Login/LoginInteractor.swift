//
//  LoginInteractor.swift
//  CleanSwiftDemo1
//
//  Created by zeba on 26/11/19.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginBusinessLogic {
  func doSomething(request: Login.User.Request)
}

protocol LoginDataStore {
  //var name: String { get set }
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    
    var presenter: LoginPresentationLogic?
    var loginWorker: LoginWorker?
    var validationWorker: ValidationWorker?
    
    // MARK: - Do something
    func doSomething(request: Login.User.Request) {
        validationWorker = ValidationWorker()
        validationWorker?.validateLoginRequest(request: request, completionHandler: { [weak self] success, meesage in
            guard let self = self else { return }
            if success {
                self.loginWorker = LoginWorker()
                self.loginWorker?.login(email: request.loginInfo.userName, password: request.loginInfo.password, completionHandler: { loginResp -> Void in
                    
                    if loginResp?.token != nil {
                        let response = Login.User.Response(succes: true, message: meesage)
                        self.presenter?.presentSomething(response: response)
                    } else {
                        let response = Login.User.Response(succes: false, message: loginResp?.reason)
                        self.presenter?.presentSomething(response: response)
                    }
                })
            } else {
                let response = Login.User.Response(succes: success,message: meesage)
                self.presenter?.presentSomething(response: response)
            }
        })
    }
}
