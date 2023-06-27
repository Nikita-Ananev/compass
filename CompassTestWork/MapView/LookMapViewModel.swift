//
//  LookMapViewModel.swift
//  CompassTestWork
//
//  Created by Никита Ананьев on 22.06.2023.
//

import UIKit
import MapboxMaps
import RxSwift

class LookMapViewModel {
    
    let locations = BehaviorSubject<[Location]>(value: [])
    
    func fetchLocations() {
        guard let url = URL(string: "https://gist.githubusercontent.com/Nikita-Ananev/75f4a08c91b0406f4fae2b887820bbd4/raw/946a6ff4c7d8e1c3743a30b4a9cd58777d452e8e/data.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let welcome = try decoder.decode(Welcome.self, from: data)
                let locations = welcome.locations
                DispatchQueue.main.async {
                    self?.locations.onNext(locations)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

