//
//  MapView.swift
//  compass
//
//  Created by Никита Ананьев on 18.06.2023.
//

import UIKit
import MapboxMaps
import RxSwift
import AVKit

class LookMapView: UIViewController {
    //MARK: Variables
    internal var mapView: MapView!
    private let disposeBag = DisposeBag()
    private var viewModel: LookMapViewModel!
    var router: Router!

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupViewModel()
        centerMap(at: CLLocationCoordinate2D(latitude: 59.9386, longitude: 30.3141)) // Координаты СПБ
        viewModel.fetchLocations()
    }
    
    //MARK: SETUP
    private func setupMapView() {
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoiYW5hbmV2MTk5NCIsImEiOiJjbGo0aWU3M3kwMmtuM2xwYTdzZTlocjliIn0.3o1ncWWbnkoXG9vMTXpgBQ")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
    }
    
    private func setupViewModel() {
        viewModel = LookMapViewModel()
        viewModel.locations
            .subscribe(onNext: { [weak self] locations in
                self?.addAnnotations(for: locations)
            })
            .disposed(by: disposeBag)
    }
    
    private func centerMap(at coordinate: CLLocationCoordinate2D) {
        let cameraOptions = CameraOptions(center: coordinate, zoom: 10)
        mapView.mapboxMap.setCamera(to: cameraOptions)
    }
    
    private func createSampleView(withText text: String) -> AnnotationButton {
        let button = AnnotationButton(type: .system)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.titleLabel?.numberOfLines = 0
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        return button
    }
    private func addAnnotations(for locations: [Location]) {
        for location in locations {
            let coordinate = location.geometry.coordinates
            let options = ViewAnnotationOptions(
                geometry: Point(CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0])),
                width: 100,
                height: 40,
                allowOverlap: false,
                anchor: .center
            )
            let annotationButton = createSampleView(withText: "Click to watch")
            annotationButton.cameraUrl = location.properties.cameraURL
            mapView.bringSubviewToFront(annotationButton)
            try! mapView.viewAnnotations.add(annotationButton, options: options)
        }
    }
    
    @objc func buttonAction(sender: AnnotationButton!) {
        guard let urlString = sender.cameraUrl else {return}
        guard let url = URL(string: urlString) else {return}
        
        //MARK: Перенести в роутер
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
       }
}

