//
//  MainViewController.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation




class MainViewController: UIViewController {
    var presenter: MainPresenterProtocol!
    
    @IBOutlet weak var createRouteButton: UIBarButtonItem!
    @IBOutlet weak var clearRouteButton: UIBarButtonItem!
    @IBOutlet weak var saveRouteButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    private var routesButton: UIBarButtonItem?
    
    private var fromAnnotation: MKPointAnnotation?
    private var toAnnotation: MKPointAnnotation?
    private var polyline: MKPolyline?
    
    private var spinner: UIActivityIndicatorView?
    private let locationManager = CLLocationManager()
    private var locationIsSet = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.configureView()
    }
    
    // MARK: - Action methods
    
    @IBAction func currentLocation(_ sender: Any) {
        presenter.currentLocationTap()
    }
    
    @IBAction func createRouteClick(_ sender: Any){
        presenter.createRouteTap()
    }
    
    
    @IBAction func clearRouteClick(_ sender: Any) {
        presenter.clearRouteTap()
    }
    
    
    @IBAction func saveRouteClick(_ sender: Any) {
        presenter.saveRouteTap()
    }
    
    @objc func menuClick(param: UIBarButtonItem) {
        presenter.showRouteHistoryTap()
    }
        
    @objc func triggerTouchAction(gestureReconizer: UIGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizer.State.ended {
            self.initTap()
            let location = gestureReconizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            self.presenter.longTap(coordinate: coordinate)
        }
    }
}


extension MainViewController: MainViewProtocol {
    
    // MARK: - MainViewProtocol methods
    
    func initTap() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(triggerTouchAction(gestureReconizer:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func showListRouteButton(_ isShow: Bool) {
        self.routesButton?.hidden(!isShow)
    }
    
    func showSaveRouteButton(_ isShow: Bool) {
        self.saveRouteButton.hidden(!isShow)
    }
    
    func showCreateRouteButton(_ isShow: Bool) {
        self.createRouteButton.hidden(!isShow)
    }
    
    func showClearRouteButton(_ isShow: Bool) {
        self.clearRouteButton.hidden(!isShow)
    }
    
    // MARK: - Init Bar buttons methods
    
    func initBarItem() {
        routesButton = UIBarButtonItem(title: "List".localized(),
                                            style: .done,
                                            target: self,
                                            action: #selector(menuClick(param:)))
        self.navigationItem.rightBarButtonItem = routesButton
        self.navigationItem.rightBarButtonItem?.hidden(false)
        
        createRouteButton.title = "Create".localized()
        saveRouteButton.title = "Save".localized()
        clearRouteButton.title = "Clear".localized()
    }
    
    // MARK: - MapView methods
    
    func zoomRegion(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let c1 = CLLocation(latitude: start.latitude, longitude: start.longitude)
        let c2 = CLLocation(latitude: end.latitude, longitude: end.longitude)
        let zoom = c1.distance(from: c2) * 1.2
        let region1 = MKCoordinateRegion(center: start, latitudinalMeters: zoom, longitudinalMeters: zoom)
        self.mapView.setRegion(region1, animated: true)
    }
    
    func initMap(source: String){
        mapView.delegate = self
        mapView.isUserInteractionEnabled = true
        let overlay = MKTileOverlay(urlTemplate: source)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .aboveLabels)
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, isStartPoint: Bool){
        let newAnnatation = MKPointAnnotation()
        newAnnatation.coordinate = coordinate
        mapView.addAnnotation(newAnnatation)
        
        if isStartPoint {
            fromAnnotation = newAnnatation
        } else {
            toAnnotation = newAnnatation
        }
    }
    
    func clearAllRoutes() {
        if let pol = polyline {
            mapView.removeOverlay(pol)
            polyline = nil
        }
        
        if let ann = fromAnnotation {
            mapView.removeAnnotation(ann)
            fromAnnotation = nil
        }
        
        if let ann = toAnnotation {
            mapView.removeAnnotation(ann)
            toAnnotation = nil
        }
    }
    
    func addRoutePolyline(coordinates:[CLLocationCoordinate2D]) {
        let polylineList = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polylineList)
        polyline = polylineList
    }
    
    // MARK: - Dialog view methods
    
    func showError(_ error: String) {
        let alertController = UIAlertController(title: "error".localized(), message: error, preferredStyle: .alert)
        self.present(alertController,animated: true, completion: nil)
        alertController.dismiss(animated: true, completion: nil)
    }
    
    func showSuccessSave(isSuccess: Bool) {
        let title = isSuccess ? "Success".localized() : "Error".localized()
        let message = isSuccess ? "Save success".localized() : "Error".localized()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController,animated: true, completion: nil)
        alertController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View state methods
    
    func changeRouteBuildState(_ state: RouteBuildState) {
        switch state {
        case .ChoosePointA:
            self.title = "Choose point A".localized()
        case .ChoosePointB:
            self.title = "Choose point B".localized()
        case .BuildRoute:
            self.title = "Build Route".localized()
        case .SaveRoute:
            self.title = "Save Route".localized()
        case .YourRoute:
            self.title = "Your Route".localized()
        }
    }
    
    func showLouderSpinner(_ isShow: Bool) {
        if let spiner = spinner {
            spiner.willMove(toWindow: nil)
            spiner.removeFromSuperview()
            self.spinner = nil
            if !isShow {return}
        }
        let spin = UIActivityIndicatorView(style: .large)
        spin.translatesAutoresizingMaskIntoConstraints = false
        spin.startAnimating()
        self.view.addSubview(spin)
        spin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spin.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.spinner = spin
    }
    
    // MARK: - Location methods
    
    func setCurrentRegion(_ center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    func initLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }
}

extension MainViewController: MKMapViewDelegate  {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKTileOverlay {
            let renderer = MKTileOverlayRenderer(overlay: overlay)
            return renderer
        } else if let polyline = overlay as? MKPolyline {
            let lineRenderer = MKPolylineRenderer(polyline: polyline)
            lineRenderer.strokeColor = .purple
            lineRenderer.lineWidth = 6.0
            return lineRenderer
        } else {
            return MKTileOverlayRenderer()
        }
    }
}

extension MainViewController: CLLocationManagerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locationIsSet {
            presenter.currentLocationTap()
            locationIsSet = true
        }
    }
}






