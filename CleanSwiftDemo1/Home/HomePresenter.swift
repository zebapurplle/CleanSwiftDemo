//
//  HomePresenter.swift
//  CleanSwiftDemo1
//
//  Created by Purplle on 15/02/22.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomePresentationLogic
{
  func presentSomething(response: Home.User.Response)
}

class HomePresenter: HomePresentationLogic
{
    weak var viewController: HomeDisplayLogic?
    
    // MARK: Do something
    func presentSomething(response: Home.User.Response) {
        let viewModel = Home.User.ViewModel(userList: response.users)
        viewController?.displaySomething(viewModel: viewModel)
    }
}
