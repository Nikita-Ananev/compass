//
//  Router.swift
//  compass
//
//  Created by Никита Ананьев on 18.06.2023.
//

import UIKit

class Router {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToMapView() {
        if let existingMapView = navigationController.viewControllers.first(where: { $0 is LookMapView }) {
            navigationController.popToViewController(existingMapView, animated: true)
        } else {
            let mapView = LookMapView()
            mapView.router = self
            navigationController.pushViewController(mapView, animated: true)
        }
    }

}
