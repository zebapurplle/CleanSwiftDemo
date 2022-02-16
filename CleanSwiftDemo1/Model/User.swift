//
//  User.swift
//  CleanSwiftDemo1
//
//  Created by Purplle on 16/02/22.
//

import Foundation

struct UserModel : Codable {
    let id : Int?
    let name : String?
    let email : String?
    let gender : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case email = "email"
        case gender = "gender"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}

