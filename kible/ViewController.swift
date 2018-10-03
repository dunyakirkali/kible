//
//  ViewController.swift
//  kible
//
//  Created by Dunya Kirkali on 10/3/18.
//  Copyright © 2018 Ahtung. All rights reserved.
//

import UIKit
import CoreLocation

extension Double {
    var toRadians: Double { return self * .pi / 180 }
}

class ViewController: UIViewController {

    @IBOutlet weak var arrowImage: UIImageView!
    
    let kabe: CLLocation = CLLocation(
        latitude: CLLocationDegrees(21.422645),
        longitude: CLLocationDegrees(39.826159)
    )
    var lastLocation: CLLocation? = nil
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
}

public extension CLLocation {
    func bearingToLocationRadian(_ destinationLocation: CLLocation) -> CGFloat {
        
        let lat1 = self.coordinate.latitude.toRadians
        let lon1 = self.coordinate.longitude.toRadians
        
        let lat2 = destinationLocation.coordinate.latitude.toRadians
        let lon2 = destinationLocation.coordinate.longitude.toRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return CGFloat(radiansBearing)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        UIView.animate(withDuration: 0.5) {
            let angle = (self.lastLocation?.bearingToLocationRadian(self.kabe))! - CGFloat(newHeading.trueHeading.toRadians)
            
            self.arrowImage.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        lastLocation = currentLocation // store this location somewhere
    }
}
