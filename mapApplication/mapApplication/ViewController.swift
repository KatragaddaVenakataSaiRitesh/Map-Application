//
//  ViewController.swift
//  mapApplication
//
//  Created by ritesh Chowdary on 6/17/20.
//  Copyright © 2020 Ritesh Chowdary. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var inDistance: UITextView!
    @IBOutlet weak var cenDistance: UITextView!
    
    let locationManager = CLLocationManager()
    var myAnnotations = [CLLocation]()
    let letters = ["A","B","C","D","E"]
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //mapView.showsUserLocation = false
        mapView.delegate = self
        var rloc = MKCoordinateRegion();
        rloc.center.latitude = 50.000000;
        rloc.center.longitude = -85.000000;
        rloc.span.latitudeDelta = 10.0;
        rloc.span.longitudeDelta = 10.0;
        self.mapView.region = rloc;
        let one = UITapGestureRecognizer(target: self, action: #selector(addPin(_:)))
        mapView.addGestureRecognizer(one)
    }
    @objc func addPin(_ sender: UIGestureRecognizer){
        
        if myAnnotations.count < 5 {
        let touchPoint = sender.location(in: mapView)
        let touchLocation = mapView.convert(touchPoint,toCoordinateFrom: mapView)
        let location = CLLocation(latitude: touchLocation.latitude, longitude: touchLocation.longitude)
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = touchLocation
        myAnnotation.title = "\(touchLocation.latitude) \(touchLocation.longitude)"
        myAnnotations.append(location)
        self.mapView.addAnnotation(myAnnotation)
            
        }
            
        else {
            createPolyline(mapView: mapView)
            myTextView.text = "you can add only 5 pins"
        }
    }
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations:[CLLocation]) {
        if let newLocation = locations.last {
            let latitudeString = "\(newLocation.coordinate.latitude)"
            let longitudeString = "\(newLocation.coordinate.longitude)"
            myTextView.text = "my Location :\nLatitude: " + latitudeString + " | Longitude: " + longitudeString
}
}
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let id = MKMapViewDefaultAnnotationViewReuseIdentifier
        if let design = mapView.dequeueReusableAnnotationView(withIdentifier: id, for: annotation) as? MKMarkerAnnotationView{
            design.titleVisibility = .visible
            design.markerTintColor = .black
            if i<5{
            design.glyphText = letters[i]
            i += 1
            }
            design.glyphTintColor = .white
            
            return design
        }
         return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

          let line = MKPolylineRenderer(overlay: overlay)

        line.strokeColor = UIColor.green
          line.lineWidth = 3.8
          line.fillColor = UIColor.red.withAlphaComponent(0.5)
         

          return line
      }
     func createPolyline(mapView: MKMapView) {
        let pin0 = CLLocationCoordinate2DMake(myAnnotations[0].coordinate.latitude, myAnnotations[0].coordinate.longitude);
         let pin1 = CLLocationCoordinate2DMake( myAnnotations[1].coordinate.latitude, myAnnotations[1].coordinate.longitude);
         let pin2 = CLLocationCoordinate2DMake( myAnnotations[2].coordinate.latitude, myAnnotations[2].coordinate.longitude);
         let pin3 = CLLocationCoordinate2DMake( myAnnotations[3].coordinate.latitude, myAnnotations[3].coordinate.longitude);
        let pin4 = CLLocationCoordinate2DMake( myAnnotations[4].coordinate.latitude, myAnnotations[4].coordinate.longitude);

         let pin5 = CLLocationCoordinate2DMake( myAnnotations[0].coordinate.latitude, myAnnotations[0].coordinate.longitude);

         let pins: [CLLocationCoordinate2D]
         pins = [pin0,pin1, pin2, pin3, pin4, pin5 ]

         let geodesic = MKGeodesicPolyline(coordinates: pins, count: 6)
         mapView.addOverlay(geodesic)
         
        let dist0 = CLLocation( latitude: myAnnotations[0].coordinate.latitude, longitude: myAnnotations[0].coordinate.longitude);
        let dist1 = CLLocation( latitude: myAnnotations[1].coordinate.latitude, longitude: myAnnotations[1].coordinate.longitude);
        let dist2 = CLLocation( latitude: myAnnotations[2].coordinate.latitude, longitude: myAnnotations[2].coordinate.longitude);
        let dist3 = CLLocation( latitude: myAnnotations[3].coordinate.latitude, longitude: myAnnotations[3].coordinate.longitude);
        let dist4 = CLLocation( latitude: myAnnotations[4].coordinate.latitude, longitude: myAnnotations[4].coordinate.longitude);
        let dist5 = CLLocation( latitude:myAnnotations[0].coordinate.latitude, longitude: myAnnotations[0].coordinate.longitude);

         let Mdist: [CLLocation]
         Mdist = [dist0,dist1, dist2, dist3, dist4, dist5]
        
         let distanceAB = dist0.distance(from: dist1)
         let distanceBC = dist1.distance(from: dist2)
         let distanceCD = dist2.distance(from: dist3)
         let distanceDE = dist3.distance(from: dist4)
         let distanceEA = dist4.distance(from: dist5)

         let totalDistance = distanceAB + distanceBC + distanceCD + distanceDE + distanceEA
        
         inDistance.text? = "A -> B: \(distanceAB/1000) KM \nB -> C: \(distanceBC/1000) KM \nC -> D: \(distanceCD/1000) KM \nD -> E: \(distanceDE/1000) KM \nE -> A: \(distanceEA/1000) KM \nTotal Distance: \(totalDistance/1000)"
        cenDistance.text? = "\(totalDistance/1000) Km"
        
        
        
    }
    
}

