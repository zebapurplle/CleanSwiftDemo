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
    var multiPartData: APIMultiPartFormData?
    
    /// In init function of APIRequestModel the API URL is compulsory object all other are optional
    /// - parameters:
    ///   - url: API request url
    ///   - type: API request type
    ///   - parameters: APIParameter
    ///   - encoding: encoding description
    ///   - headers: headers description
    ///   - multipartdata: multipartdata object
    
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
         type: HTTPMethod,
         parameters: APIParameter,
         encoding: ParameterEncoding,
         headers: HTTPHeaders,
         uploadFileUrls: [String],
         multiPartData: APIMultiPartFormData) {
        self.url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.type = type
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.multiPartData = multiPartData
    }
    init(url: String,
         type: HTTPMethod? = HTTPMethod.get,
         parameters: APIParameter? = nil,
         encoding: ParameterEncoding? = URLEncoding.default,
         headers: HTTPHeaders? = nil,
         uploadFileUrls: [String]? = nil,
         multiPartData: APIMultiPartFormData? = nil) {
        self.url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.type = type ?? HTTPMethod.get
        self.parameters = parameters
        self.encoding = encoding ?? URLEncoding.default
        self.headers = headers
        self.multiPartData = multiPartData
    }
}

/// Model used to create parameters for APIRequestModel
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
/// Model used to create mulipart data for requuest model
struct APIMultiPartFormData {
    
    var uploadFile: [Any]?
    var fileNames: [String]?
    var serverKeys: [String]?
    var mimeTypes: [String]?
    var imageQuality: Float?
    var multipartformData: [MultiPartFormData]?
    
    /// Can provide the array of MultiPartFormData object or can upload file , file name, server key and mime type separately
    /// If the keys are same for file Names, server Keys and mimeTypes then only single object is required in corresponding array
    /// - parameters:
    ///   - uploadFile: file's of type Data,Images or drive urls
    ///   - fileNames: fileNames description
    ///   - serverKeys: serverKeys description
    ///   - mimeTypes: mimeTypes description
    ///   - ImageQuality: ImageQuality description
    init(multipartformData: [MultiPartFormData]) {
        self.multipartformData = multipartformData
    }
    
    init(uploadFile: [Any]? = nil,
         fileNames: [String]? = nil,
         serverKeys: [String]? = nil,
         mimeTypes: [String]? = nil) {
        self.uploadFile = uploadFile
        self.fileNames = fileNames
        self.serverKeys = serverKeys
        self.mimeTypes = mimeTypes
    }
    
    init(uploadFile: [Any]? = nil,
         fileNames: [String]? = nil,
         serverKeys: [String]? = nil,
         mimeTypes: [String]? = nil,
         imageQuality: Float? = 0.1) {
        self.uploadFile = uploadFile
        self.fileNames = fileNames
        self.serverKeys = serverKeys
        self.mimeTypes = mimeTypes
        self.imageQuality = imageQuality
    }
    
    init(multipartformData: [MultiPartFormData]? = nil,
         uploadFile: [Any]? = nil,
         fileNames: [String]? = nil,
         serverKeys: [String]? = nil,
         mimeTypes: [String]? = nil,
         imageQuality: Float? = 0.1) {
        self.uploadFile = uploadFile
        self.fileNames = fileNames
        self.serverKeys = serverKeys
        self.mimeTypes = mimeTypes
        self.imageQuality = imageQuality
        self.multipartformData = multipartformData
    }
}

/// MultiPartFormData model
struct MultiPartFormData {
    var uploadFile: Data = Data()
    var fileName: String = ""
    var serverKey: String = ""
    var mimeTypes: String = ""
    
    /// MultiPartFormData data model
    ///
    /// - parameters:
    ///   - uploadFile: upload data file
    ///   - fileName: fileName description
    ///   - serverKey: serverKey description
    ///   - mimeTypes: mimeTypes description
    init(uploadFile: Data, fileName: String, serverKey: String, mimeTypes: String ) {
        self.uploadFile = uploadFile
        self.fileName = fileName
        self.serverKey = serverKey
        self.mimeTypes = mimeTypes
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
