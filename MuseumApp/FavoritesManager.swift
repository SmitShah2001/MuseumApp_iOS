//
//  FavoritesManager.swift
//  MuseumApp
//
//  Created by user247453 on 14/08/24.
//

import Foundation


class FavoritesManager {
    static let shared = FavoritesManager()
    
    private init() {}
    
    private let favoritesKey = "favorites"
    
    private var favorites: [Int: ArtObject] = [:]
    
    func getFavorites() -> [ArtObject] {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let savedFavorites = try? JSONDecoder().decode([ArtObject].self, from: data) {
            return savedFavorites
        }
        return []
    }
    
    func addFavorite(artObject: ArtObject) {
        favorites[artObject.objectID] = artObject
        saveFavorites()
    }
    
    func removeFavorite(artObject: ArtObject) {
        favorites.removeValue(forKey: artObject.objectID)
        saveFavorites()
    }
    
    private func saveFavorites() {
        let favoriteArray = Array(favorites.values)
        if let data = try? JSONEncoder().encode(favoriteArray) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}
