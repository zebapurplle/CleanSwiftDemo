//
//  APIWrapperErrors.swift
//  Purplle
//
//  Created by Zeba on 01/03/22.
//

import Foundation
import UIKit
import SystemConfiguration

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
struct ResponseCode {
    static let kSuccessRequest  =  (200 ... 299)
    static let pBadRequest = 400
    static let kUnauthorised  = 401
    static let Forbidden = 403
    static let NotFound = 404
    static let InternalServerError = 500
    static let NotImplemented = 501
}

public struct APIWrapperGlobalFunctions {
    static let KnownErrorCodes: [Int: String] = [
        ResponseCode.pBadRequest: ErrorMessage.pBadRequest,
        ResponseCode.kUnauthorised: ErrorMessage.pUnauthorised,
        ResponseCode.Forbidden: ErrorMessage.Forbidden,
        ResponseCode.NotFound: ErrorMessage.NotFound,
        ResponseCode.InternalServerError: ErrorMessage.InternalServerError,
        ResponseCode.NotImplemented: ErrorMessage.NotImplemented]
    static let kErrorMessageKey = ["message", "msg", "error"]
    static func handleUnauthorisedAccess() {
        print("LOGOUT handler call")
    }
  
    static func dataFromImage(image: UIImage, compressionQuality: Float) -> Data? {
        return image.jpegData(compressionQuality: CGFloat(compressionQuality))
    }
  
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
