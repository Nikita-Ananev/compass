//
//  Location.swift
//  CompassTestWork
//
//  Created by Никита Ананьев on 22.06.2023.
//


import Foundation

struct Welcome: Codable {
    let type: String
    let locations: [Location]
}

struct Location: Codable {
    let id: Int
    let type: String
    let properties: Properties
    let geometry: Geometry
}

struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

struct Properties: Codable {
    let cameraURL: String
    
    enum CodingKeys: String, CodingKey {
        case cameraURL = "camera_url"
    }
}
