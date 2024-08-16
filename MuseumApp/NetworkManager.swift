//
//  NetworkManager.swift
//  MuseumApp
//
//  Created by user247453 on 8/10/24.
//

import Foundation
import UIKit
import CoreData

class NetworkManager {
    
    private init() {}
    
    static let shared = NetworkManager()
    
    
    // Fetch objectIDs
    func fetchObjectIDs(completion: @escaping ([Int]?) -> Void) {
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/objects"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                print("Received data: \(apiResponse.objectIDs.count) objects")
                completion(apiResponse.objectIDs)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    // Fetch ArtObject details by ID
    func fetchArtObjectDetails(objectID: Int, completion: @escaping (ArtObject?) -> Void) {
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(objectID)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL for objectID: \(objectID)")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data for objectID \(objectID): \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received for objectID \(objectID)")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let artObject = try decoder.decode(ArtObject.self, from: data)
                print("Received art object: \(artObject.title)")
                completion(artObject)
            } catch {
                print("Failed to decode JSON for objectID \(objectID): \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    
    
    struct APIResponse: Codable {
        let objectIDs: [Int]
    }
}
