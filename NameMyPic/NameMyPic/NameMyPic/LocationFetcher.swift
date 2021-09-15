//
//  LocationFetcher.swift
//  NameMyPic
//
//  Created by EO on 13/09/21.
//  

import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    
    var lastKnownLongitude: String {
        guard let long = lastKnownLocation?.longitude else { return "" }
        
        return String(format: "%.2f", long)
    }
    
    var lastKnownLatitude: String {
        guard let lat = lastKnownLocation?.latitude else { return "" }
        
        return String(format: "%.2f", lat)
    }
    
    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}

