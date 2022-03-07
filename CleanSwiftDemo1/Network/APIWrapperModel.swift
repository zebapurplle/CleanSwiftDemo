//
//  APIWrapperModel.swift
//  Purplle
//
//  Created by Zeba on 01/03/22.
//

import Foundation
import Alamofire

/// Model used to request a API
struct APIRequestModel {
    
    var url: String = ""
    var type: HTTPMethod = HTTPMethod.get
    var parameters: APIParameter?
    var encoding: ParameterEncoding = URLEncoding.default
    var headers: HTTPHeaders?
    
    /// In init function of APIRequestModel the API URL is compulsory object all other are optional
    /// - parameters:
    ///   - url: API request url
    ///   - type: API request type
    ///   - parameters: APIParameter
    ///   - encoding: encoding description
    ///   - headers: headers description
    ///
    init(url: String) {
        self.url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    init(url: String, type: HTTPMethod) {
        self.url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.type = type
    }
    init(url: String, type: HTTPMethod, parameters: APIParameter) {
        self.url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.type = type
        self.parameters = parameters
    }
    init(url: String, type: HTTPMethod, parameters: APIParameter, encoding: ParameterEncoding) {
        self.url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.type = type
        self.parameters = parameters
        self.encoding = encoding
    }
    init(url: String, type: HTTPMethod, parameters: APIParameter, encoding: ParameterEncoding, headers: HTTPHeaders) {
        self.url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.type = type
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
    
    init(url: String,
         type: HTTPMethod? = HTTPMethod.get,
         parameters: APIParameter? = nil,
         encoding: ParameterEncoding? = URLEncoding.default,
         headers: HTTPHeaders? = nil) {
        self.url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.type = type ?? HTTPMethod.get
        self.parameters = parameters
        self.encoding = encoding ?? URLEncoding.default
        self.headers = headers
    }
}
/// model used to create parameters for APIRequestModel
struct APIParameter {
    var keys: [String] = []
    var values: [Any] = []
    var parameters: [String: Any] = [String: Any]()
    
    /// Can pass keys and values in seperate array
    /// Or can pass parameters directly
    /// - parameters:
    ///   - keys: Parameter key
    ///   - values: corresponding values
    ///   - parameters: complete Parameter
    init(keys: [String], values: [Any]) {
        self.keys = keys
        self.values = values
        self.createParam()
    }
    init(parameters: [String: Any]) {
        self.parameters = parameters
    }
    /// This function generate key value for API request
    mutating func createParam() {
        let minValue = min((self.keys ).count, (self.values ).count)
        for index in 0..<minValue {
            let key = self.keys[index]
            self.parameters[key] = self.values[index]
        }
    }
}

struct ErrorResponse {
    
    private var errorList: [String] = []
    private var errorCode: Int = 500
    private var errorObject: DataResponse<Any>?
    
    init(errorList: [String], errorCode: Int, errorObject: DataResponse<Any>? = nil) {
        self.errorList = errorList
        self.errorCode = errorCode
        self.errorObject = errorObject
    }
    
    func code() -> Int {
        return errorCode
    }
    
    func error() -> String {
        return errorList[0]
    }
    
    func errors() -> [String] {
        return errorList
    }
    
    func object() -> DataResponse<Any>? {
        return errorObject
    }
}
