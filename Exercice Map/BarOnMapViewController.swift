//
//  BarOnMapViewController.swift
//  Exercice Map
//
//  Created by Fady on 14/11/2018.
//  Copyright © 2018 SuperFadx. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class BarOnMapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate
 {

    @IBOutlet weak var mapView: MKMapView!
    
    var bar : PenseBete.Bar? = nil
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let region = MKCoordinateRegion(center:
            CLLocationCoordinate2D(latitude:  bar?.latitude! ?? 0.0, longitude: bar?.longitude! ?? 0.0), span: span)
        mapView.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.title = bar?.name!
        annotation.coordinate = CLLocationCoordinate2D(latitude: bar?.latitude! ?? 0.0, longitude: bar?.longitude! ?? 0.0)
        mapView.addAnnotation(annotation)
        
        
        self.locationManager.requestAlwaysAuthorization()

        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "John Doe"
        annotation.subtitle = "Position actuelle"
        mapView.addAnnotation(annotation)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
