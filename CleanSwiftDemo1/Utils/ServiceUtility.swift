//
//  ServiceUtility.swift
//  CleanSwiftDemo1
//
//  Created by Zeba on 5/9/17.
//

import UIKit
import AFNetworking

class ServiceUtility: NSObject {
    
    typealias CompletionHandler = (_ success:Bool,_ resp:NSDictionary) -> Void
    typealias CompletionHandler1 = (_ success:Bool,_ resp:NSArray) -> Void
    
    typealias SuccessHandler = (_ success:Bool)->Void
    typealias ErrorHandler = (_ success:Bool)->Void
    typealias AuthHandler = (_ success:Bool)->Void
    
    //Mark callWebServiceWithLink with [String:Any]
    class func callWebServiceWithLink(_ URL:String , params:[String : Any] , completionHandler: @escaping CompletionHandler)
    {
        let manager = AFHTTPSessionManager()
        
        manager.responseSerializer = AFJSONResponseSerializer()
        print(params)
        manager.post(URL, parameters: params, progress: nil,
                     success: {
            requestOperation , response in
            let dataFromServer :NSDictionary = (response as! NSDictionary)
            
            if (dataFromServer.object(forKey: "token") as? String) != nil {
                completionHandler(true,dataFromServer)
            } else {
                completionHandler(false,dataFromServer)
            }
            print(response)            
        },
                     failure: {
            requestOperation, error in
            print(error.localizedDescription)
            
            let err = NSMutableDictionary()
            if let urlResponse = requestOperation?.response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                err.setValue(status, forKey: "statusCode")
            }else{
                err.setValue(0, forKey: "statusCode")
            }
            err.setValue(error.localizedDescription, forKey: "message")
            let dataFromServer :NSDictionary = (err)
            print(dataFromServer)
            completionHandler(false,dataFromServer)
        })
        
    }
    
    
    //Mark callWebServiceWithLink with NSMutable Dictionary
    class func callWebServiceWithLink(_ URL:String , parameters:NSMutableDictionary , completionHandler: @escaping CompletionHandler1)
    {
        let manager = AFHTTPSessionManager()
        
        manager.responseSerializer = AFJSONResponseSerializer()
        print(parameters)
        manager.get(URL, parameters: parameters, progress: nil,
                     success: {
            requestOperation , response in
            let dataFromServer : NSArray = (response as! NSArray)
            completionHandler(true,dataFromServer)
            
        },
                     failure: {
            requestOperation, error in
            print(error.localizedDescription)
            
            let err = NSMutableDictionary()
            if let urlResponse = requestOperation?.response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                err.setValue(status, forKey: "statusCode")
            }else{
                err.setValue(0, forKey: "statusCode")
            }
            err.setValue(error.localizedDescription, forKey: "message")
            let dataFromServer :NSDictionary = (err)
            print(dataFromServer)
            completionHandler(false,NSArray())
        })
        
    }
    
    //Mark callWebServiceWithLink with NSMutable Dictionary with image
    class func callWebServiceWithLinkWithImage(_ URL:String , parameters:NSMutableDictionary ,uploadImage:UIImage,imageParam: String, completionHandler: @escaping CompletionHandler)
    {
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        print(parameters)
        manager.post(URL, parameters: parameters, constructingBodyWith: { (formData) in
            formData.appendPart(
                withFileData: uploadImage.jpegData(compressionQuality: 0.1)!,
                name: imageParam,
                fileName: "image.jpeg",
                mimeType: "image/jpeg")
            
        }, progress: { (Progress) in
            print(Progress.totalUnitCount)
        }, success:
                        {
            requestOperation, response  in
            
            let dataFromServer :NSDictionary = (response as! NSDictionary)
            completionHandler(true,dataFromServer)
            
        },
                     failure: {
            requestOperation, error in
            print(error.localizedDescription)
            
            let err = NSMutableDictionary()
            if let urlResponse = requestOperation?.response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                err.setValue(status, forKey: "statusCode")
            }else{
                err.setValue(0, forKey: "statusCode")
            }
            err.setValue(error.localizedDescription, forKey: "message")
            let dataFromServer :NSDictionary = (err)
            print(dataFromServer)
            completionHandler(false,dataFromServer)
        })
        
    }
}
