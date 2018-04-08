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
import MessageUI
import Alamofire
import SwiftKeychainWrapper
import Firebase

class LocalizacaoVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,AVAudioPlayerDelegate,  MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    var route: MKRoute?
    var circle:MKCircle!
    var circle2:MKCircle!
    
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
            mapView.showsUserLocation = true
        }
        //-22.9691293,-43.3728939
        
        //        var points = [CLLocationCoordinate2D(latitude: -22.9691293, longitude: -43.3728939),
        //                      CLLocationCoordinate2D(latitude: -22.9691293, longitude: -43.3729939),
        //                      CLLocationCoordinate2D(latitude: -22.9692293, longitude: -43.3725939),
        //                      CLLocationCoordinate2D(latitude: -22.9694293, longitude: -43.3723939)]
        //        let tile = MKPolygon(coordinates: &points, count: points.count)
        //        tile.title = "Moree"
        //        mapView.add(tile)
        
//        showCircle(coordinate: CLLocationCoordinate2D(latitude: -22.9691293, longitude: -43.3728939), radius: 2000)

        var coordinates = CLLocationCoordinate2D(latitude: -22.9691293, longitude: -43.3728939)
        circle = MKCircle(center: coordinates, radius: 200)
        mapView.add(circle)

        
        coordinates = CLLocationCoordinate2D(latitude: -22.9691393, longitude: -43.3829739)
        circle = MKCircle(center: coordinates, radius: 200)
        mapView.add(circle)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let session = AVAudioSession()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.allowBluetooth)
            //blueBtn.setTitle("Bluetooth OFF", for: .normal)
        } catch {
            print("AVAudioSession error!")
        }
        
    }
        
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self) {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.red
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
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
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func teste(_ sender: Any) {
        //        if (MFMessageComposeViewController.canSendText()) {
        //            let controller = MFMessageComposeViewController()
        //            controller.body = "Alerta de Botão Panico"
        //            controller.recipients = ["11989696606"]
        //            controller.messageComposeDelegate = self
        //            self.present(controller, animated: true, completion: nil)
        //        }
        var celularessms = ""
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let panicoRef = ref.child("users").child(uid!).child("panico")
        
        _ = panicoRef.observe(.value, with: {
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let value = snap.value as? NSDictionary {
                        if celularessms != "" {
                            celularessms = celularessms + ","
                        }
                        celularessms = "\(celularessms)\(value["celular"] ?? "")"
                    }
                }
            }
            
            let userData = ["apikey": "acs42gi17Yo-LySp56T5Lm5Ex5QPXntvkimboOK15B",
                            "numbers" : celularessms,
                            "message" : "Alerta de botão de Panico",
                            "sender" : "Rio2c"]
            let headers = ["Content-Type": "application/x-www-form-urlencoded"]
            
            let url = "https://api.txtlocal.com/send/?"
            Alamofire.request(url, method: .post, parameters: userData, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("envio com sucesso")
                case .failure(let error):
                    print(0,"Error")
                }
            }
        })
        
    }
    
    //remoteControlReceivedWithEvent
    override func remoteControlReceived(with event: UIEvent?) {
        let rc = event?.subtype
        print("rc.rawValue: \(rc?.rawValue)")
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Alerta de Botão Panico"
            controller.recipients = ["11989696606"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
}

