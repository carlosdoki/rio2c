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

class LocalizacaoVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, AVAudioPlayerDelegate,  MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var route: MKRoute?
    var circle:MKCircle!
    
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
        
        carregaDados()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)),
                                               name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                               object: nil)
        
        let session = AVAudioSession()
        do {
            try
                session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.allowBluetooth)
            
        } catch {
            print("AVAudioSession error!")
        }
        
    }
    
    func carregaDados() {
        
        let ref = Database.database().reference()
        _ = ref.child("zona").child("assalto").observe(.value, with: {
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let value = snap.value as? NSDictionary {
                        if value["longitude"] != nil && value["raio"] != nil {
                            let coordinates = CLLocationCoordinate2D(latitude: value["latitude"] as! Double, longitude: value["longitude"] as! Double)
                            self.circle = MKCircle(center: coordinates, radius: CLLocationDistance(value["raio"] as! Int ?? 0))
                            self.circle.title = "assalto"
                            self.mapView.add(self.circle)
                            
                            self.pointAnnotation = MKPointAnnotation()
                            self.pointAnnotation.coordinate = coordinates
                            self.pointAnnotation.title = "Assalto"
                            self.pointAnnotation.subtitle = "Zona de Assalto"
                            
                            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "pin")
                            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                        }
                    }
                }
            }
        })
        
        _ = ref.child("zona").child("bicicleta").observe(.value, with: {
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let value = snap.value as? NSDictionary {
                        let coordinates = CLLocationCoordinate2D(latitude: value["latitude"] as! Double, longitude: value["longitude"] as! Double)
                        self.circle = MKCircle(center: coordinates, radius: CLLocationDistance(value["raio"] as! Int))
                        self.circle.title = "bicicleta"
                        self.mapView.add(self.circle)
                        
                        self.pointAnnotation = MKPointAnnotation()
                        self.pointAnnotation.coordinate = coordinates
                        self.pointAnnotation.title = "Bicicleta"
                        self.pointAnnotation.subtitle = "Zona de Roubo de Bicicleta"
                        
                        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "pin")
                        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                    }
                }
            }
        })
        
        _ = ref.child("zona").child("carga").observe(.value, with: {
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let value = snap.value as? NSDictionary {
                        let coordinates = CLLocationCoordinate2D(latitude: value["latitude"] as! Double, longitude: value["longitude"] as! Double)
                        self.circle = MKCircle(center: coordinates, radius: CLLocationDistance(value["raio"] as! Int))
                        self.circle.title = "carga"
                        self.mapView.add(self.circle)
                        
                        self.pointAnnotation = MKPointAnnotation()
                        self.pointAnnotation.coordinate = coordinates
                        self.pointAnnotation.title = "Carga"
                        self.pointAnnotation.subtitle = "Zona de roubo de carga"
                        
                        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "pin")
                        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                    }
                }
            }
        })
        
        _ = ref.child("zona").child("veiculos").observe(.value, with: {
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let value = snap.value as? NSDictionary {
                        let coordinates = CLLocationCoordinate2D(latitude: value["latitude"] as! Double, longitude: value["longitude"] as! Double)
                        self.circle = MKCircle(center: coordinates, radius: CLLocationDistance(value["raio"] as! Int))
                        self.circle.title = "veiculos"
                        self.mapView.add(self.circle)
                        
                        self.pointAnnotation = MKPointAnnotation()
                        self.pointAnnotation.coordinate = coordinates
                        self.pointAnnotation.title = "Veiculos"
                        self.pointAnnotation.subtitle = "Zona de assalto de Veiculos"
                        
                        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "pin")
                        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                    }
                }
            }
        })
        _ = ref.child("zona").child("celular").observe(.value, with: {
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let value = snap.value as? NSDictionary {
                        let coordinates = CLLocationCoordinate2D(latitude: value["latitude"] as! Double, longitude: value["longitude"] as! Double)
                        self.circle = MKCircle(center: coordinates, radius: CLLocationDistance(value["raio"] as! Int))
                        self.circle.title = "celular"
                        self.mapView.add(self.circle)
                        
                        self.pointAnnotation = MKPointAnnotation()
                        self.pointAnnotation.coordinate = coordinates
                        self.pointAnnotation.title = "Celular"
                        self.pointAnnotation.subtitle = "Zona de roubo de Celulares"
                        
                        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "pin")
                        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                    }
                }
            }
        })
        _ = ref.child("zona").child("latrocinio").observe(.value, with: {
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let value = snap.value as? NSDictionary {
                        let coordinates = CLLocationCoordinate2D(latitude: value["latitude"] as! Double, longitude: value["longitude"] as! Double)
                        self.circle = MKCircle(center: coordinates, radius: CLLocationDistance(value["raio"] as! Int))
                        self.circle.title = "latrocinio"
                        self.mapView.add(self.circle)
                        
                        self.pointAnnotation = MKPointAnnotation()
                        self.pointAnnotation.coordinate = coordinates
                        self.pointAnnotation.title = "Latrocinio"
                        self.pointAnnotation.subtitle = "Zona de Latronicio"
                        
                        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "pin")
                        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                    }
                }
            }
        })
        _ = ref.child("zona").child("homicidio").observe(.value, with: {
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let value = snap.value as? NSDictionary {
                        let coordinates = CLLocationCoordinate2D(latitude: value["latitude"] as! Double, longitude: value["longitude"] as! Double)
                        self.circle = MKCircle(center: coordinates, radius: CLLocationDistance(value["raio"] as! Int))
                        self.circle.title = "homicidio"
                        self.mapView.add(self.circle)
                        
                        self.pointAnnotation = MKPointAnnotation()
                        self.pointAnnotation.coordinate = coordinates
                        self.pointAnnotation.title = "Homocidio"
                        self.pointAnnotation.subtitle = "Zona de Homicidio"
                        
                        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "pin")
                        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                    }
                }
            }
        })
    }
    
    @objc func volumeChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            var celularessms = ""
            
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            
            //let coordinate1 = CLLocation(latitude: (locationManger.location?.coordinate.latitude)!, longitude: (locationManger.location?.coordinate.longitude)!)
            
            let hist_panicoRef = ref.child("users").child(uid!).child("historico_panico")
            var childId = hist_panicoRef.childByAutoId()
            var latitude = childId.child("latitude")
            latitude.setValue(locationManager.location?.coordinate.latitude)
            var longitude = childId.child("longitude")
            longitude.setValue(locationManager.location?.coordinate.longitude)
            var data = childId.child("data")
            data.setValue(round(Date().timeIntervalSince1970))
            
            let zona_assalto = ref.child("zona").child("assalto")
            childId = zona_assalto.childByAutoId()
            latitude = childId.child("latitude")
            latitude.setValue(locationManager.location?.coordinate.latitude)
            longitude = childId.child("longitude")
            longitude.setValue(locationManager.location?.coordinate.longitude)
            let raio = childId.child("raio")
            raio.setValue(1200)
            
            
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
                
                if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = "Alerta de Botão Panico, localização - https://www.google.com/maps/@\(self.locationManager.location?.coordinate.latitude),\(self.locationManager.location?.coordinate.longitude)z"
                    controller.recipients = [celularessms]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                }
                
                let userData = ["apikey": "acs42gi17Yo-LySp56T5Lm5Ex5QPXntvkimboOK15B",
                                "numbers" : celularessms,
                                "message" : "Alerta de botão de Panico",
                                "sender" : "Rio2c"]
                let headers = ["Content-Type": "application/x-www-form-urlencoded"]
                
                let url = "https://api.txtlocal.com/send/?"
                
                

                
                //                Alamofire.request(url, method: .post, parameters: userData, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                //                    switch response.result {
                //                    case .success:
                //                        print("envio com sucesso")
                //                    case .failure(let error):
                //                        print(0,"Error")
                //                    }
                //                }
            })
            //carregaDados()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self) {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            
            if overlay.title == "assalto" {
                circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.1)
                circleRenderer.strokeColor = UIColor.red
            }
            if overlay.title == "bicicleta" {
                circleRenderer.fillColor = UIColor.brown.withAlphaComponent(0.1)
                circleRenderer.strokeColor = UIColor.brown
            }
            if overlay.title == "carga" {
                circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
                circleRenderer.strokeColor = UIColor.blue
            }
            if overlay.title == "celular" {
                circleRenderer.fillColor = UIColor.yellow.withAlphaComponent(0.1)
                circleRenderer.strokeColor = UIColor.yellow
            }
            if overlay.title == "veiculos" {
                circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.1)
                circleRenderer.strokeColor = UIColor.purple
            }
            if overlay.title == "latrocinio" {
                circleRenderer.fillColor = UIColor.cyan.withAlphaComponent(0.1)
                circleRenderer.strokeColor = UIColor.cyan
            }
            if overlay.title == "homicidio" {
                circleRenderer.fillColor = UIColor.orange.withAlphaComponent(0.1)
                circleRenderer.strokeColor = UIColor.orange
            }
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
    
    @IBAction func centralizarPressed(_ sender: UITapGestureRecognizer) {
        //if let userLocation = locations.last {
        let viewRegion = MKCoordinateRegionMakeWithDistance((currentLocation?.coordinate)!, 2000, 2000)
        mapView.setRegion(viewRegion, animated: false)
        //}
    }
    
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

