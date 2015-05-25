//
//  IApi.swift
//  upaty
//
//  Created by Tuan Phung on 11/30/14.
//  Copyright (c) 2014 Tuan Phung. All rights reserved.
//

import Foundation

typealias ExApiCompletionHandler = (response: AnyObject?, error: NSError?) -> ()

enum HTTPMethod: String
{
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

/* Interface Object for File uploading in Multipart/form-data */
public class ExFileUpload {
    var data: NSData?
    var mimeType: String?
    
    init(data: NSData?, mimeType: String) {
        self.data = data
        self.mimeType = mimeType
    }
}

class IApi {
    
    /* Must be overrided in Subclass */
     func getBaseApiURL() -> String {
        return ""
    }
    /**/
    
    func configuredManager() -> AFHTTPRequestOperationManager {
        var manager = AFHTTPRequestOperationManager(baseURL: nil)
//        manager.requestSerializer.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        return manager
    }
    
    func dateTimeFormat() -> String {
        return "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    /*
        Main method to execute REST API, multipart/form-data is default
        Support GET, POST, PUT
        Specially, POST & PUT allow including File data
    */
    func processRequest(endpoint: String!, method: HTTPMethod, parameters: [String: AnyObject?]?, completionHandler: ExApiCompletionHandler?) {
        
        // Init an instance of AFHTTPRequestOperationManager with some pre-configs
        let manager = configuredManager()
        
        // Callback function for success case
        var successHandler = {
            (operantion: AFHTTPRequestOperation!, response: AnyObject!) -> () in
                completionHandler?(response: response, error: nil)
                return
        }
        
        // Callback function for failure case
        var failureHandler = {
            (operantion: AFHTTPRequestOperation!, error: NSError!) -> () in
            completionHandler?(response: operantion.responseString, error: error)
            return
        }
        
        // Compose full-path of URL request
        var url = getBaseApiURL() + endpoint

        // Remove nil value in parameters
        var standardizeParameters = [String: AnyObject]()
        if let _parameters = parameters{
            for (key,value) in _parameters {
                if (value != nil) {
                    if value is NSDate {
                        if let date = value as? NSDate {
                            standardizeParameters[key] = date.ex_toString(self.dateTimeFormat(), timeZone: NSTimeZone(name: "UTC"))
                        }
                    }
                    else {
                        standardizeParameters[key] = value
                    }
                }
            }
        }
        
        println("Invoke \(method.rawValue) \(url)")
        println("Paramters \(standardizeParameters)")
        
        switch method {
            case .GET:
                manager.GET(url, parameters: standardizeParameters, success: successHandler, failure: failureHandler)
            case .POST, .PUT, .DELETE:
                processFormDataRequest(manager, url: url, method: method, parameters: standardizeParameters, successHandler: successHandler, failureHandler: failureHandler)
            default:
                println("Method \(method.rawValue) is not support")
        }
    }
    
    /* 
        *Method to perform multipart/form-data including uploading file
        *File is an instance of ExFileUpload
    */
    func processFormDataRequest(manager: AFHTTPRequestOperationManager, url: String!, method: HTTPMethod, parameters: [String: AnyObject], successHandler: (operation: AFHTTPRequestOperation!, response: AnyObject!) -> (), failureHandler: (operation: AFHTTPRequestOperation!, error: NSError!) -> ()) {
        
        // Pick up all ExFileUpload instance in paramters, to build FormData
        var constructingBodyBlock = {
            (formData: AFMultipartFormData!) -> () in
            for (key, value) in parameters {
                if let file = value as? ExFileUpload {
                    // Will ignore IFileUpload if data is nil
                    if let data = file.data {
                        let mimeType = file.mimeType
                        formData.appendPartWithFileData(data, name: key, fileName: "\(key).png", mimeType: mimeType)
                    }
                }
            }
        }
        
        // Create an new list of paramters, that excluded IFileUpload's instances.
        var otherParamters = [String: AnyObject]()
        for (key, value) in parameters {
            if let file = value as? ExFileUpload {
                //ignore IFileUpload instance
            }
            else {
                otherParamters[key] = value
            }
        }

        switch method {
            case .POST:
                manager.POST(url, parameters: otherParamters, constructingBodyWithBlock: constructingBodyBlock, success: successHandler, failure: failureHandler)
            case .PUT:
                manager.PUT(url, parameters: otherParamters, constructingBodyWithBlock: constructingBodyBlock, success: successHandler, failure: failureHandler)
            case .DELETE:
                manager.DELETE(url, parameters: otherParamters, constructingBodyWithBlock: constructingBodyBlock, success: successHandler, failure: failureHandler)
            default:
                println("Method \(method) is not support Multipart/Form-data")
        }
    }
}