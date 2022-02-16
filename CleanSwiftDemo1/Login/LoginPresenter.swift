//
//  LoginPresenter.swift
//  CleanSwiftDemo1
//
//  Created by zeba on 26/11/19.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginPresentationLogic {
    
  func presentSomething(response: Login.User.Response)
}

class LoginPresenter: LoginPresentationLogic {
    
    weak var viewController: LoginDisplayLogic?
    
    // MARK: Do something
    func presentSomething(response: Login.User.Response) {
        
        let viewModel = Login.User.ViewModel(isSuccess: response.succes, message: response.message)
        viewController?.displaySomething(viewModel: viewModel)
    }
}