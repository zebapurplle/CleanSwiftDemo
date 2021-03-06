//
//  HomeModels.swift
//  CleanSwiftDemo1
//
//  Created by Purplle on 15/02/22.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Home
{
    // MARK: Use cases
    enum User
    {
        struct Request
        {
        }
        struct Response
        {
            var users: [UserModel]
        }
        struct ViewModel
        {
            var userList: [UserModel]
        }
    }
}
