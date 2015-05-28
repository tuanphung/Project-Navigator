//
//  GGApi.swift
//  Project Navigator
//
//  Created by Tuan Phung on 5/27/15.
//  Copyright (c) 2015 Tuan Phung. All rights reserved.
//

import Foundation

let GOOGLE_API_KEY = "AIzaSyDmnVP89vy2EZYiCvcWQTiQOMP1bxXp5gM"

class GGDirection {
    var points = [CLLocationCoordinate2D]()
    
    // in m
    var distance: Double = 0
    
    // in seconds
    var duration: Int32 = 0
}

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
    
    class func getDirectionFrom(fromCoordinate: CLLocationCoordinate2D, toCoordinate: CLLocationCoordinate2D, completion:(direction: GGDirection?) -> ()) {
        let gGeocodingURL = "http://maps.googleapis.com/maps/api/directions/json"
        let parameters = [
            "origin": "\(fromCoordinate.latitude), \(fromCoordinate.longitude)",
            "destination": "\(toCoordinate.latitude), \(toCoordinate.longitude)",
            "language": "en",
            "mode": "walking",
            "sensor": "false"
        ]
        
        var manager = AFHTTPRequestOperationManager(baseURL: nil)
        manager.responseSerializer.acceptableContentTypes = nil
        
        manager.GET(gGeocodingURL, parameters: parameters, success: {
            (operation, response) -> () in
            let json = JSON(response)
            if let routes = json["routes"].array where routes.count > 0 {
                let firstRoute = routes[0]
                var direction = GGDirection()
                
                if let distance = firstRoute["legs"][0]["distance"]["value"].number {
                    direction.distance = distance.doubleValue
                }
                
                if let duration = firstRoute["legs"][0]["duration"]["value"].number {
                    direction.duration = duration.intValue
                }
                
                // Add fromCoordinate as first point
                direction.points.append(fromCoordinate)
                
                // Decode polyline to list of CLLocationCoordinate
                if let encodedPoints = firstRoute["overview_polyline"]["points"].string {
                    var polyLinePath = GMSPath(fromEncodedPath: encodedPoints)
                    for i in 0..<polyLinePath.count() {
                        direction.points.append(polyLinePath.coordinateAtIndex(i))
                    }
                }
                
                // Add fromCoordinate as last point
                direction.points.append(toCoordinate)
                
                completion(direction: direction)
                return
            }
            
            // else case
            completion(direction: nil)
            }, failure: {
                (operation, response) -> () in
                completion(direction: nil)
        })
    }
}