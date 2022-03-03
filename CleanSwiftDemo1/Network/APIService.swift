//
//  APIService.swift
//  Purplle
//
//  Created by Zeba on 01/03/22.
//

import Foundation
import Alamofire

enum APIResponse {
    case success(String?)
    case error(String)
}

protocol CodableType: Codable {}
protocol CodableModel: APIWrapperModelType, CodableType {}
protocol APIService {
    associatedtype APICodable: Codable
}

protocol APIWrapperModelType: Codable {
    static var httpMethod: HTTPMethod { get }
    static var url: String {get}
    static var params: [String: Any] {get}
    static var headers: [String: String] {get}
    func apiWrapper() -> APIWrapper?
    static func apiWrapper() -> APIWrapper
}

// MARK: - Provide default apiWrapper
extension APIWrapperModelType {
    
    static var httpMethod: HTTPMethod { return .get }
    static var url: String { return "" }
    static var params: [String: Any] {return [:]}
    static var headers: [String: String] {return ["":""]} /// Add your header key and value
    
    static func apiWrapper() -> APIWrapper {
        var model = APIRequestModel(url: url, type: httpMethod)
        if httpMethod == .post {
            model.encoding = JSONEncoding.default
        } else if httpMethod == .put {
            model.encoding = JSONEncoding.default
        }
        model.parameters = APIParameter(parameters: params)
        model.headers = headers
        return APIWrapper(request: model)
    }
    
    func apiWrapper() -> APIWrapper? {
        do {
            let param = try asDictionary()
            var model = APIRequestModel(url: Self.url, type: Self.httpMethod)
            if Self.httpMethod == .post {
                model.encoding = JSONEncoding.default
            } else if Self.httpMethod == .put {
                model.encoding = URLEncoding.queryString
            }
            model.parameters = APIParameter(parameters: param)
            model.headers = Self.headers
            return APIWrapper(request: model)
        } catch _ {
            return nil
        }
    }
}

// MARK: - Web Service
extension APIService {
    
    typealias CompletionHandler = (_ response: APIResponse, _ model: APICodable?) -> Void
    
    static func loadData(apiWrapper: APIWrapper, completion: @escaping CompletionHandler) {
        // Call Web Service
        print(apiWrapper)
        self.callWebService(apiWrapper, completion: completion)
    }
   
    static private func callWebService(_ apiWrapper: APIWrapper, completion: @escaping CompletionHandler) {
        apiWrapper.requestAPI(success: { object in
            handleResponse(object: object, response: .success(""), completion: completion)
        }, failed: { error in
            print(error)
            if let errorObject = error.object()?.result.value
                as? [String: AnyObject] {
                print(errorObject)
                handleResponse(object: errorObject as AnyObject,
                               response: .error(error.error()),
                               completion: completion)
            } else {
                completion(APIResponse.error(error.error()), nil)
            }
        })
    }
   
    static private func handleResponse(object: AnyObject,
                                       response: APIResponse,
                                       completion: @escaping CompletionHandler) {
        do {
            //1. Convert JSONObject to Data
            let data = try JSONSerialization.data(
                withJSONObject: object,
                options: [])
            print("Server Response \(object)")
            //2. try to parse data to associated model
            let model = try JSONDecoder().decode(APICodable.self, from: data)
            //3. Model created successfully go back with model and response
            let msg = object["message"] as? String ?? ""
            switch response {
            case .error(let msg):
                completion(APIResponse.error(msg), model)
            case .success:
                completion(APIResponse.success(msg), model)
            }
        } catch let error as NSError {
            // An error occurred go back with erro
            print(error)
            completion(APIResponse.error(error.description), nil)
        }
    }
}
// MARK: - Encodable
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                options: .allowFragments) as? [String: Any] else {
                                                                    throw NSError()
        }
        return dictionary
    }
}
