//
//  FavoritesViewController.swift
//  MuseumApp
//
//  Created by user247453 on 14/08/24.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    
    
    @IBOutlet weak var favTableView: UITableView!
    
    var favoriteArtObjects: [ArtObject] = []
    var searchHistory: [ArtEntities] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()

            fetchSearchHistory()
            
            
            
            
            // Register the cell class
                    favTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
                    
            
            favTableView.dataSource = self
            favTableView.delegate = self
            loadFavorites()
        }
    
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            loadFavorites()
        }
        
        private func loadFavorites() {
            // Fetch favorites from FavoritesManager
            favoriteArtObjects = FavoritesManager.shared.getFavorites()
            
            
            // Debugging print to check data
                print("Loaded favorites: \(favoriteArtObjects)")
            
            favTableView.reloadData()
        }
        
        // MARK: - UITableViewDataSource Methods

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favoriteArtObjects.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
            let artObject = favoriteArtObjects[indexPath.row]
            cell.textLabel?.text = artObject.title
            cell.detailTextLabel?.text = artObject.artistDisplayName
            return cell
        }

        // MARK: - UITableViewDelegate Methods

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let artObject = favoriteArtObjects[indexPath.row]
            
            
            
            print("Selected art object: \(artObject.title)")
            
            performSegue(withIdentifier: "toShowDetailFav", sender: artObject)
        }
    
    func fetchSearchHistory() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest: NSFetchRequest<ArtEntities> = ArtEntities.fetchRequest()
            
            

            do {
                searchHistory = try context.fetch(fetchRequest)
                favTableView.reloadData()
            } catch {
                print("Failed to fetch search history: \(error)")
            }
        }
    
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowDetailFav" {
                if let detailVC = segue.destination as? DetailsViewController,
                   let artObject = sender as? ArtObject {
                    detailVC.artObject = artObject
                    detailVC.isFavorite = true
                    print("Preparing segue for DetailViewController with isFavorite = true")
                } else {
                    print("Segue identifier or sender is not correct")
                }
            }
        }
    }
