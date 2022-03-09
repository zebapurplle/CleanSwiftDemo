//
//  APIWrapper.swift
//  Purplle
//
//  Created by Zeba on 01/03/22.
//

import Foundation
import Alamofire

/// To request API, creat object of this wrapper, Init the object with APIRequestModel
/// You can on the API debug mode by isDebugOn = true , default it's Off
struct APIWrapper {
    var isDebugOn: Bool = false
    var requestModel: APIRequestModel = APIRequestModel(url: "")
    init(request: APIRequestModel) {
        self.requestModel = request
    }
    
    /// This is the only function  will call after creating the APIRequestModel
    /// This function internally calls API according to the API Request Model and return the output
    /// - Parameters:
    ///   - success: This block will call when API has a response. you can fetch the response directly from object
    ///   - failed: This block will call when there is an error while getting the response.
    /// The error is a collection of String, there is at least one error present in that Array
    func requestAPI(success:@escaping (AnyObject) -> Void, failed:@escaping (ErrorResponse) -> Void) {
        // Check for Network connection
        if !APIWrapperGlobalFunctions.isNetworkConnected() {
            failed(APIWrapperGlobalFunctions.noNetworkError())
            return
        }
        self.printRequestModel()
        // Call internal function fro API calling
        self.request(success: { (response) in
            success(response)
        }, failed: { (error) in
            failed(error)
        })
    }
}

// MARK: - RequestAPI
extension APIWrapper {
    
    /// This function call request API using Amlofire
    ///
    /// - Parameters:
    ///   - success: When there is valid data response
    ///   - failed: failed if any error occur
    private func request(success:@escaping (AnyObject) -> Void, failed:@escaping (ErrorResponse) -> Void) {
        let params = requestModel.parameters?.parameters ?? [:]
        Alamofire.request(requestModel.url,
                          method: requestModel.type,
                          parameters: params,
                          encoding: requestModel.encoding,
                          headers: requestModel.headers).responseJSON { (response) -> Void in
            self.handleResponse(response: response, success: { (responseValue) in
                success(responseValue)
            }, failed: { (error) in
                failed(error)
            })
        }
    }
    
    /// Cancel request
    func cancelRequest() {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach { $0.cancel() }
        }
    }
}

extension APIWrapper {
    
    /// This function is used to Upload the files from
    ///
    /// - Parameters:
    ///   - progressValue: this call back return thr % of data uploaded
    ///   - success: success when uploading will finish
    ///   - failed: in case of any error this call back call with collection of error
    func requestAPI(progressValue:@escaping(Double) -> Void,
                    success:@escaping (AnyObject) -> Void,
                    failed:@escaping (ErrorResponse) -> Void) {
        // Check for Network connection
        if !APIWrapperGlobalFunctions.isNetworkConnected() {
            failed(APIWrapperGlobalFunctions.noNetworkError())
            return
        }
        self.printRequestModel()
        // Call internal function fro API calling
        self.upload(progressValue: { (progress) in
            progressValue(progress)
        }, success: { (response) in
            success(response)
        }, failed: { (error) in
            failed(error)
        })
    }
}

// MARK: - Error handling
extension APIWrapper {
    
    /// This fucnction handle API response off all request
    ///
    /// - Parameters:
    ///   - response: API DataResponse
    ///   - success: Success closer
    ///   - failed: failed closer
    func handleResponse(response: DataResponse<Any>,
                        success: @escaping (AnyObject) -> Void,
                        failed: @escaping (ErrorResponse) -> Void) {
        debugPrint(object: "API Response for url => \(self.requestModel.url )" as AnyObject)
        self.debugPrint(object: response as AnyObject)
        switch response.result {
        case .success:
            self.handleSuccess(response: response, success: { (responseValue) in
                success(responseValue)
            }, failed: { (error) in
                failed(error)
            })
        case .failure:
            self.debugPrint(object: response.error as AnyObject)
            self.handleErrror(responseData: response, failed: { (error) in
                failed(error)
            })
        }
    }
    
    /// This funciton handdle the error Success of API
    ///
    /// - Parameters:
    ///   - response: DataResponse from the API
    private func handleSuccess(response: DataResponse<Any>,
                               success: @escaping (AnyObject) -> Void,
                               failed: @escaping (ErrorResponse) -> Void) {
        let responseCode = response.response?.statusCode ?? ResponseCode.pBadRequest
        if ResponseCode.kSuccessRequest.contains(responseCode) {
            success(response.result.value as AnyObject)
        } else {
            self.handleErrror(responseData: response, failed: { (error) in
                failed(error)
            })
        }
    }
    
    /// This funciton handdle the error response of API
    ///
    /// - Parameters:
    ///   - response: DataResponse from the API
    ///   - failed: Error closer
    private func handleErrror(responseData: DataResponse<Any>, failed: @escaping (ErrorResponse) -> Void) {
        let statusCode = responseData.response?.statusCode ?? ResponseCode.pBadRequest
        var errorMessage = [ErrorMessage.pSomethingWentWrong]
        // Check For Logout 401
        if checkUnauthorisedAccess(errorCode: statusCode) {
            errorMessage = [ErrorMessage.pUnauthorised]
            APIWrapperGlobalFunctions.handleUnauthorisedAccess()
        } else {
            ///  API request error
            if responseData.error != nil {
                errorMessage = [self.createErrorForFailure(errorCode: statusCode)]
            } else { // DB related error
                errorMessage = self.createErrorForSuccess(responseData: responseData)
            }
        }
        failed(ErrorResponse(errorList: errorMessage, errorCode: statusCode, errorObject: responseData))
    }
    
    /// This function check the error code for Unauthorised access 401
    ///
    /// - Parameter errorCode: API response code
    private func checkUnauthorisedAccess(errorCode: Int) -> Bool {
        if errorCode == ResponseCode.kUnauthorised {
            return true
        } else {
            return false
        }
    }
    
    /// This function return error message in case of API Success
    ///
    /// - Parameter responseData: API responseData
    /// - Returns: error Message
    private  func createErrorForSuccess(responseData: DataResponse<Any>) -> [String] {
        if let reponseValue = responseData.result.value as? [String: AnyObject] {
            return self.fetchErrorFromResponse(reponse: reponseValue)
        } else {
            return [ErrorMessage.pSomethingWentWrong]
        }
    }
    
    /// This function fetch error from response body
    ///
    /// - Parameter reponse: reponse body as [String : AnyObject]
    /// - Returns: Error String
    private func fetchErrorFromResponse(reponse: [String: AnyObject]) -> [String] {
        var errorValue: AnyObject?
        for messageKey in APIWrapperGlobalFunctions.kErrorMessageKey {
            if let error = reponse[messageKey] {
                errorValue = error
                break
            }
        }
        guard let error = errorValue else {
            return  [ErrorMessage.pSomethingWentWrong]
        }
        if error is String && (error as? String) != ""{
            return [error as? String ?? ErrorMessage.pSomethingWentWrong]
        } else {
            return self.fetchErrorStringFromMulipleErrors(errorDic: error)
        }
    }
    
    /// This function fetch single error message from multiple errors
    ///
    /// - Parameter errorDic: Error object
    /// - Returns: error Message
    private func fetchErrorStringFromMulipleErrors(errorDic: AnyObject) -> [String] {
        var finalErrors: [String]?
        if errorDic is NSDictionary {
            let errorValueArray = (errorDic as? NSDictionary ?? NSDictionary()).allValues
            if errorValueArray.count != 0 {
                if errorValueArray is [String] {
                    finalErrors = errorValueArray as? [String]
                } else {
                    for items in errorValueArray where items is [String] {
                        if (items as? [String] ?? []).count != 0 && (items as? [String] ?? [])[0] != "" {
                            finalErrors?.append((items as? [String] ?? [])[0])
                        }
                    }
                }
            }
        } else if errorDic is [String] {
            if (errorDic as? [String] ??  [""]).count != 0 {
                finalErrors  = errorDic as? [String]
            }
        }
        finalErrors = finalErrors?.filter { $0 != "" } // remove blank object
        if finalErrors?.count != 0 {
            return finalErrors ?? [ErrorMessage.pSomethingWentWrong]
        }
        return [ErrorMessage.pSomethingWentWrong]
    }
    
    /// This function return error message in case of API Failure
    ///
    /// - Parameter errorCode: API error code
    /// - Returns: error Message
    private func createErrorForFailure(errorCode: Int) -> String {
        let allKnownErrorCode =  APIWrapperGlobalFunctions.KnownErrorCodes.keys
        if allKnownErrorCode.contains(errorCode) {
            return  APIWrapperGlobalFunctions.KnownErrorCodes[errorCode] ?? ErrorMessage.pSomethingWentWrong
        }
        return ErrorMessage.pSomethingWentWrong
    }
    
    /// This fucniton print the log if debuging mode is ON
    ///
    /// - Parameter object: print Object
    func debugPrint(object: AnyObject) {
        if self.isDebugOn {
            print(object)
        }
    }
    
    /// Print the request model
    private func printRequestModel() {
        debugPrint(object: "Request Model" as AnyObject)
        debugPrint(object: "URL=> \(requestModel.url)" as AnyObject)
        debugPrint(object: "TYPE=> \(requestModel.type)" as AnyObject)
        debugPrint(object: "PARAMS=> \(String(describing: requestModel.parameters?.parameters))" as AnyObject)
        debugPrint(object: "HEADER=> \(String(describing: requestModel.headers))" as AnyObject)
    }
}
