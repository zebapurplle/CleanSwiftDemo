//
//  APIWrapper+Extensions.swift
//  Purplle
//
//  Created by Zeba on 07/03/22.
//

import Foundation
import Alamofire

// MARK: - UploadAPI
extension APIWrapper {
    
    /// This function call request API using Amlofire
    ///
    /// - Parameters:
    ///   - progressValue: this call back return thr % of data uploaded
    ///   - success: When there is valid data response
    ///   - failed: failed if any error occur
    func upload(progressValue: @escaping(Double) -> Void,
                success: @escaping (AnyObject) -> Void,
                failed: @escaping (ErrorResponse) -> Void) {
        if !self.checkInputDataFiles() {
            failed(APIWrapperGlobalFunctions.internalServerError())
            self.debugPrint(object: ErrorMessage.pUnKnownRequest as AnyObject)
            return }
        guard let url = URL(string: requestModel.url) else {
            failed(APIWrapperGlobalFunctions.internalServerError())
            self.debugPrint(object: ErrorMessage.pSomethingWentWrong as AnyObject)
            return }
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = requestModel.type.rawValue
        requestUrl.allHTTPHeaderFields = requestModel.headers
        Alamofire.upload(
            multipartFormData: { multipartformData in
                let   multiPartData = self.creatMultiformDataSet()
                for muliPart in multiPartData {
                    multipartformData.append(muliPart.uploadFile, withName: muliPart.fileName,
                                             fileName: muliPart.serverKey, mimeType: muliPart.mimeTypes)
                }
                if let parametersDict = self.requestModel.parameters?.parameters {
                    // add Parameters in multipartdata
                    for (key, value) in parametersDict {
                        let newValue = "\(value as AnyObject)"
                        let valueData =  newValue.data(using: String
                            .Encoding(rawValue: String
                                .Encoding(rawValue: String
                                    .Encoding.utf8.rawValue).rawValue)) ?? Data()
                        multipartformData.append(valueData, withName: key)
                    }
                }
        }, with: requestUrl,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    upload.uploadProgress { progress in
                        let percentUpload: Double = Double(progress.completedUnitCount/progress.totalUnitCount)
                        self.debugPrint(object: percentUpload as AnyObject)
                        progressValue(percentUpload)
                    }
                    self.handleResponse(response: response, success: { (responseValue) in
                        success(responseValue)
                    }, failed: { (error) in  failed(error)})
                }
            case .failure(let error):
                self.debugPrint(object: error as AnyObject)
                failed(APIWrapperGlobalFunctions.internalServerError())
            }
        })
    }
    
    /// This function check the input upload file count
    ///
    /// - Returns: true if input model is in correct formate
    private func checkInputDataFiles() -> Bool {
        let minimumFileCount = requestModel.multiPartData?.uploadFile?.count ?? 0
        if minimumFileCount != 0 { // There is some file to upload
            if (requestModel.multiPartData?.fileNames?.count ?? 0) == 0 { // atlest one file name should be there
                return false
            } else if (requestModel.multiPartData?.serverKeys?.count ?? 0) == 0 {
                // atlest one server Keys should be there
                return false
            } else if (requestModel.multiPartData?.mimeTypes?.count ?? 0) == 0 {
                // atlest one mime Types should be there
                return false
            } else {
                return true // desired input
            }
        } else {
            return true // Nothing to upload
        }
    }
    /// This function create multiform data using Input Model
    ///
    /// - Returns: final object of multipartFormData
    private func creatMultiformDataSet() -> [MultiPartFormData] {
        var multipartData: [MultiPartFormData] = [MultiPartFormData]()
        if let multipartformData = requestModel.multiPartData?.multipartformData {
            multipartData.append(contentsOf: multipartformData)
        }
        guard let uploadFile = requestModel.multiPartData?.uploadFile else {
            return multipartData
        }
        for (index, file) in uploadFile.enumerated() {
            var data: Data?
            var fileName: String = self.getFileName(index: index)
            if file is UIImage {
                let image = file as? UIImage ?? UIImage()
                if fileName == "" {
                    fileName = image.accessibilityIdentifier ?? ""
                }
                data = APIWrapperGlobalFunctions
                    .dataFromImage(image: image,
                                   compressionQuality: requestModel.multiPartData?.imageQuality ?? 0.1 )
            } else if file is Data {
                data = file as? Data
            } else if let fileUrl =  file as? String {
                let url = URL(fileURLWithPath: fileUrl)
                if fileName == "" {
                    fileName = self.getFileName(file: url)
                }
                data = self.fetchDataFromFileUrl(fileUrl: url)
            }
            if let filedata = data {
                multipartData.append(self.createMultipartObject(data: filedata, index: index, filename: fileName))
            }
        }
        return multipartData
    }
    func createMultipartObject (data: Data, index: Int, filename: String) -> MultiPartFormData {
        let key = self.getServerName(index: index)
        let mimeName = self.getMimeType(index: index)
        return MultiPartFormData(uploadFile: data, fileName: filename, serverKey: key, mimeTypes: mimeName)
    }
    func fetchDataFromFileUrl(fileUrl: URL) -> Data? {
        if let image    = UIImage(contentsOfFile: fileUrl.path) {
            return APIWrapperGlobalFunctions
                .dataFromImage(image: image,
                               compressionQuality: requestModel.multiPartData?.imageQuality ?? 0.1 )
        } else {
            do {
                let filedata: Data  = try Data(contentsOf: fileUrl as URL)
                return filedata
            } catch {
                debugPrint(object: "Exception \(error.localizedDescription)" as AnyObject)
                return nil
            }
        }
    }
    /// Function fetch the file name from the file
    ///
    /// - Parameter file: input file
    /// - Returns: file name
    private func getFileName(file: URL?) -> String {
        return file?.absoluteURL.lastPathComponent ?? ""
    }
    /// This function return the Mime type from Mime array of object
    /// If mime name is comman for all the it's return the 1st one
    /// - Parameters:
    ///   - index: data set index
    /// - Returns: mime name
    private func getMimeType(index: Int) -> String {
        let mimes =  self.requestModel.multiPartData?.mimeTypes ?? []
        if index < mimes.count && mimes[index] != "" {
            return mimes[index]
        }
        return mimes[0]
    }
    /// This function return the file name
    /// If name is not given for that index it return blank
    /// - Parameters:
    ///   - index: data set index
    /// - Returns: name
    private func getFileName(index: Int) -> String {
        let serverKey = self.requestModel.multiPartData?.serverKeys ?? []
        if index < serverKey.count && serverKey[index] != "" {
            return serverKey[index]
        } else {
        }
        return ""
    }
    /// This function return the name from  inputObject
    /// If name is comman for all the it's created "<name>[index]" for that index
    /// - Parameters:
    ///   - index: data set index
    /// - Returns: name
    private func getServerName(index: Int) -> String {
        let serverKey = self.requestModel.multiPartData?.serverKeys ?? []
        if index < serverKey.count && serverKey[index] != "" {
            return serverKey[index]
        }
        return "\(serverKey)[\(index)]"
    }
}
