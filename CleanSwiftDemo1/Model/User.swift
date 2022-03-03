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

struct UserModel1 : Codable {
    let id : Int?
    let name : String?
    let age : Int?
    let salary : Int?
    let image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "employee_name"
        case age = "employee_age"
        case salary = "employee_salary"
        case image = "profile_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        salary = try values.decodeIfPresent(Int.self, forKey: .salary)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }

}

