//
//  IExUtilities.swift
//  upaty
//
//  Created by Tuan Phung on 12/14/14.
//  Copyright (c) 2014 Tuan Phung. All rights reserved.
//

import Foundation
import MapKit

class ExUtilities {
    class func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
    
    class func iOSVersion() -> CGFloat {
        let version = UIDevice.currentDevice().systemVersion
        if let number = NSNumberFormatter().numberFromString(version) {
            return CGFloat(number)
        }
        return 0
    }
    
    class func randomString(length: Int) -> String {
        let characterSet = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        var randomString = ""
        for i in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(count(characterSet))))
            randomString += characterSet.substringWithRange(Range<String.Index>(start: advance(characterSet.startIndex, randomIndex), end: advance(characterSet.startIndex, randomIndex + 1)))
        }
        
        return randomString
    }
    
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    class func addressFromCoordinate(coordinate: CLLocationCoordinate2D, completion:(address: String?) -> ()) {
        let gGeocodingURL = "http://maps.googleapis.com/maps/api/geocode/json"
        let parameters = ["latlng": "\(coordinate.latitude),\(coordinate.longitude)"]
        
        var manager = AFHTTPRequestOperationManager(baseURL: nil)
        manager.responseSerializer.acceptableContentTypes = nil
        
        manager.GET(gGeocodingURL, parameters: parameters, success: {
            (operation, response) -> () in
            let json = JSON(response)
            if let results = json["results"].array where results.count > 0 {
                let address = results[0]["formatted_address"].string
                completion(address: address)
                return
            }

            // else case
            completion(address: nil)
            
        }, failure: {
            (operation, response) -> () in
            completion(address: nil)
        })
    }
    
    class func coordinateFromAddress(address: String, completion:(coordinate: CLLocationCoordinate2D?) -> ()) {
        let gGeocodingURL = "http://maps.googleapis.com/maps/api/geocode/json"
        let parameters = ["address": address]
        
        var manager = AFHTTPRequestOperationManager(baseURL: nil)
        manager.responseSerializer.acceptableContentTypes = nil
        
        manager.GET(gGeocodingURL, parameters: parameters, success: {
            (operation, response) -> () in
            let json = JSON(response)
            if let results = json["results"].array where results.count > 0 {
                let location = results[0]["geometry"]["location"]
                if let lat = location["lat"].double, lng = location["lng"].double {
                    var coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    completion(coordinate: coordinate)
                    return
                }
            }
            // else case
            completion(coordinate: nil)
            }, failure: {
                (operation, response) -> () in
                completion(coordinate: nil)
        })
        
    }
    
    class func scaleImage(image: UIImage, inSize size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
}