//
//  Model.swift
//  MuseumApp
//
//  Created by user247453 on 8/10/24.
//
import Foundation

struct ArtObject: Codable {
    let objectID: Int
    let title: String
    let artistDisplayName: String
    let primaryImage: String
    let primaryImageSmall: String?
    let culture: String
    let period: String
    let objectDate: String
    let country: String
}

