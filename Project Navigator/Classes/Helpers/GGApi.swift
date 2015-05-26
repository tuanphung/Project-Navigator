//
//  GGApi.swift
//  Project Navigator
//
//  Created by Tuan Phung on 5/27/15.
//  Copyright (c) 2015 Tuan Phung. All rights reserved.
//

import Foundation

let GOOGLE_API_KEY = "AIzaSyDmnVP89vy2EZYiCvcWQTiQOMP1bxXp5gM"

class GGApi {
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
}