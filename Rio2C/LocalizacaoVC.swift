//
//  FirstViewController.swift
//  Rio2C
//
//  Created by Carlos Doki on 07/04/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import CoreBluetooth
import MapKit
import CoreLocation
import AVFoundation

class LocalizacaoVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,AVAudioPlayerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()

        let session = AVAudioSession()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.allowBluetooth)
            //blueBtn.setTitle("Bluetooth OFF", for: .normal)
        } catch {
            print("AVAudioSession error!")
        }
        
    }
    
    // MARK - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
    
    //remoteControlReceivedWithEvent
    override func remoteControlReceived(with event: UIEvent?) {
        let rc = event?.subtype
        print("rc.rawValue: \(rc?.rawValue)")
    }
    
}

