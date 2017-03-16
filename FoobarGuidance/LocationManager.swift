//
//  LocationManager.swift
//  FoobarGuidance
//
//  Created by Jakub Mazur on 15/03/2017.
//  Copyright © 2017 wingu AG. All rights reserved.
//

import UIKit
import CoreLocation

protocol CardSearcherProtocol {
    func cardFound(_ beacon : CLBeacon)
}

class LocationManager: NSObject {
    private override init() { }
    var delegate : CardSearcherProtocol?
    var locationCoords : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var results : [[String : Any]] = [[String : Any]]()
    var selectedResults : [[String : Any]] = [[String : Any]]()
    lazy var coreLocationManager : CLLocationManager = {
        CLLocationManager()
    }()
    static let sharedInstance: LocationManager = {
        let locationManager : LocationManager = LocationManager()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.coreLocationManager.requestAlwaysAuthorization()
            locationManager.coreLocationManager.delegate = locationManager
            locationManager.coreLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.coreLocationManager.startUpdatingLocation()
        }
        return locationManager
    }()
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationCoords = (locations.last?.coordinate)!
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.handleClosestCard(beacons)
    }
    
    func handleClosestCard(_ beacons : [CLBeacon]) {
        var beacons : [CLBeacon] = beacons.filter() {
            return $0.rssi == 0 ? false : true
        }
        beacons = beacons.sorted(by: { $0.rssi > $1.rssi })
        
        if let beacon = beacons.first {
            self.delegate?.cardFound(beacon)
        }
    }
}

extension LocationManager {
    func scanForCard() {
        let proximityCard : String = "f7826da6-4fa2-4e98-8024-bc5b71e0893f"
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: proximityCard)!, identifier: proximityCard)
        self.coreLocationManager.startRangingBeacons(in: region)
    }
}
