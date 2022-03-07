//
//  APIWrapperErrors.swift
//  Purplle
//
//  Created by Zeba on 01/03/22.
//

import Foundation
import UIKit
import SystemConfiguration

/// This stucture contains all the Error Message
struct ErrorMessage {
    static let pSomethingWentWrong = "Something went wrong. Please try again in sometime."
    static let pNoNetwork = "Sorry your request couldn’t be processed beacuse of a server issue. Please try again."
    static let pBadRequest =  "Please check the inputs then try again."
    static let pUnauthorised = "Your session has expired. Please log in again."
    static let Forbidden = "You don't have permission for this request."
    static let NotFound = "The request you are looking for is unavailable."
    static let InternalServerError = "Currently, the server is down. Please try after some time."
    static let NotImplemented = "Currently, Server can't accept these request. Please change the request."
}

/// This structure has error code for specific errors, You can change this code according to their requirement
struct ResponseCode {
    static let kSuccessRequest  =  (200 ... 299)
    static let pBadRequest = 400
    static let kUnauthorised  = 401
    static let Forbidden = 403
    static let NotFound = 404
    static let InternalServerError = 500
    static let NotImplemented = 501
}

/// We can modify this Model according to our APIs structure
public struct APIWrapperGlobalFunctions {
    static let KnownErrorCodes: [Int: String] = [
        ResponseCode.pBadRequest: ErrorMessage.pBadRequest,
        ResponseCode.kUnauthorised: ErrorMessage.pUnauthorised,
        ResponseCode.Forbidden: ErrorMessage.Forbidden,
        ResponseCode.NotFound: ErrorMessage.NotFound,
        ResponseCode.InternalServerError: ErrorMessage.InternalServerError,
        ResponseCode.NotImplemented: ErrorMessage.NotImplemented]
    
    static let kErrorMessageKey = ["message", "msg", "error"] /// You can change it according to your APIs response
    
    /// It's a custome function, To handle the Unauthorised access
    static func handleUnauthorisedAccess() {
        print("LOGOUT handler call")
    }
    
    /// This function check network connectivity
    ///
    /// - Returns: true if network is connected
    static func isNetworkConnected() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static func noNetworkError() -> ErrorResponse {
        return ErrorResponse(errorList: [ErrorMessage.pNoNetwork],
                             errorCode: ResponseCode.pBadRequest)
    }
    
    static func internalServerError(_ error: String? = nil) -> ErrorResponse {
        return ErrorResponse(errorList: [error ?? ErrorMessage.pSomethingWentWrong],
                             errorCode: ResponseCode.InternalServerError)
    }
}
