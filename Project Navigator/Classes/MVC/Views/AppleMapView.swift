//
//  AppleMapView.swift
//  Project Navigator
//
//  Created by Tuan Phung on 5/25/15.
//  Copyright (c) 2015 Tuan Phung. All rights reserved.
//

import Foundation
import MapKit

class AppleMapView: MKMapView {
    var locationManager = CLLocationManager()
    var droppedPointAnnotation = MKPointAnnotation()
    
    var defaultZoomLevel = 15
    var firstTimeLoaded = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // From iOS 8.0, this method is required before start using GPS
        if (locationManager.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        self.delegate = self
        self.showsUserLocation = true
        
        // Add a UILongPressGestureRecognizer to allow user drop a pin on map
        var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressHandle:")
        longPressRecognizer.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    var zoomLevel: Int {
        get {
            return Int(log2(360 * (Double(self.frame.size.width/256) / self.region.span.longitudeDelta)) + 1);
        }
        
        set (newZoomLevel){
            setCenterCoordinate(self.centerCoordinate, zoomLevel: newZoomLevel, animated: true)
        }
    }
    
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool){
        let span = MKCoordinateSpanMake(0, 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegionMake(centerCoordinate, span), animated: animated)
    }
    
    //MARK: Handle long press on map to drop a pin
    func longPressHandle(recognizer: UILongPressGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.Began) {
            // Remove previous dropped pin
            self.removeAnnotation(self.droppedPointAnnotation)
            
            // Convert touch point on screen to coordinate system
            var touchPoint = recognizer.locationInView(self)
            var touchCoordinate = self.convertPoint(touchPoint, toCoordinateFromView: self)
            
            // Re-allocated <droppedPointAnnotation>
            self.droppedPointAnnotation = MKPointAnnotation()
            self.droppedPointAnnotation.coordinate = touchCoordinate
            self.addAnnotation(self.droppedPointAnnotation)
            
            // Allow user drop another pin while previous pin is being decoded
            // <weak annotation> will be turned to nil if <droppedPointAnnotation> is re-allocated
            ExUtilities.addressFromCoordinate(touchCoordinate, completion: { [weak annotation = self.droppedPointAnnotation] (address) -> () in
                if let _annotation = annotation {
                    _annotation.title = address
                    self.selectAnnotation(_annotation, animated: true)
                }
            })
        }
    }
}

extension AppleMapView: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation.isKindOfClass(MKPointAnnotation.self)) {
            let pinDropIdentifier = "PinDropIdentifier"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(pinDropIdentifier) as? MKPinAnnotationView
            if (annotationView == nil) {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinDropIdentifier)
            }
            
            annotationView?.animatesDrop = true
            annotationView?.canShowCallout = true
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        NSLog("MapView didUpdateUserLocation: \(userLocation.location.coordinate)")
        
        if (!userLocation.updating) { return }
        
        // Zoom and center the map to user location if it's the first coordinate
        if self.firstTimeLoaded {
            self.centerCoordinate = userLocation.location.coordinate
            self.zoomLevel = self.defaultZoomLevel
            
            ExUtilities.addressFromCoordinate(mapView.centerCoordinate, completion: { [weak annotation = userLocation] (address) -> () in
                annotation?.title = address
                self.selectAnnotation(annotation, animated: true)
            })
        }
        else {
            // Just update address from new user location if it's not the first coordinate
            ExUtilities.addressFromCoordinate(mapView.centerCoordinate, completion: { [weak annotation = userLocation] (address) -> () in
                annotation?.title = address
            })
        }
    }
}