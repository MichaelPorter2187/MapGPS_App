//
//  ViewController.swift
//  mporter_MapGPS
//
//  Created by Michael Ray Porter, Jr on 4/18/24.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var mapSwitch: UISwitch!
    @IBOutlet weak var mapSlider: UISlider!
    
    let myAnnotation = MKPointAnnotation() //marker showing your location
    let locationManager = CLLocationManager() //reads GPS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        theMap.delegate = self
        theMap.mapType = .hybrid
        theMap.isZoomEnabled = true
        theMap.isScrollEnabled = true
        theMap.addAnnotation(myAnnotation)
        
        let tmpRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.09796, longitude: -95.98953), latitudinalMeters: 500, longitudinalMeters: 500)
        theMap.setRegion(tmpRegion, animated: true)
        
        mapSwitch.setOn(true, animated: true)
        mapSlider.maximumValue = 3.0
        mapSlider.minimumValue = 0.0
        mapSlider.setValue(1.5, animated: true)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            //activate GPS
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        default:
            break
            
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        let myLocation = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        
        theMap.setCenter(myLocation, animated: true)
        myAnnotation.coordinate = myLocation
    }
    

    @IBAction func SwitchMap(_ sender: Any) {
        
        if mapSwitch.isOn{
            theMap.mapType = .hybrid
        }else{
            theMap.mapType = .standard
        }
        
    }
    
    @IBAction func Zoom(_ sender: Any) {
     
        let miles = Double(self.mapSlider.value)
        let delta = miles / 69.0
        var currentRegion = theMap.region
        currentRegion.span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        theMap.region = currentRegion
        
    }
}

