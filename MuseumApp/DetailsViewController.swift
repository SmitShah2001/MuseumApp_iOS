//
//  DetailsViewController.swift
//  MuseumApp
//
//  Created by user247453 on 8/10/24.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var artObject: ArtObject?
    public var isFavorite: Bool = false
    
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up the table view
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        
        // Register a basic UITableViewCell
        detailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailsCell")
        
        // Load the art object data
        guard artObject != nil else { return }
        
        
//        // Fetch favorites and update UI
//                NetworkManager.shared.getFavorites { [weak self] favorites in
//                    guard let self = self else { return }
//                    if let favorites = favorites {
//                        self.isFavorite = favorites.contains { $0.objectID == self.artObject?.objectID }
//                        DispatchQueue.main.async {
//                            self.updateFavoriteButton()
//                        }
//                    }
//                }
        // Update button state
        updateFavoriteButton()
        
        // Load image
        loadImage()
        
    }
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath)
    
            // Display the appropriate information based on the row index
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Title: \(artObject?.title ?? "Unknown")"
            case 1:
                cell.textLabel?.text = "Artist: \(artObject?.artistDisplayName ?? "Unknown")"
            case 2:
                cell.textLabel?.text = "Culture: \(artObject?.culture ?? "Unknown")"
            case 3:
                cell.textLabel?.text = "Period: \(artObject?.period ?? "Unknown")"
            case 4:
                cell.textLabel?.text = "Date: \(artObject?.objectDate ?? "Unknown")"
            case 5:
                cell.textLabel?.text = "Country of Origin: \(artObject?.country ?? "Unknown")"
            default:
                cell.textLabel?.text = ""
            }
    
            return cell
        }
    

    // MARK: - Button Actions

    @IBAction func toggleFavorite(_ sender: UIBarButtonItem) {
        if isFavorite {
            removeFromFavorites()
        } else {
            addToFavorites()
        }
        
    }

    // MARK: - Helper Methods
    
    private func updateFavoriteButton() {
        
        let title = isFavorite ? "Remove from Favorites" : "Add to Favorites"
        favButton.title = title
        
        favButton.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    private func addToFavorites() {
        // Logic to add to favorites
        
        guard let artObject = artObject else { return }
               
        print("added art : \(artObject.title)")
        FavoritesManager.shared.addFavorite(artObject: artObject)
        
        // Save the art object to Core Data
        CoreDataHelper.shared.addArtObject(artObject: artObject)
            
               
        isFavorite = true
        
        
        updateFavoriteButton()
        
    }
    
    private func removeFromFavorites() {
        // Logic to remove from favorites
        
        guard let artObject = artObject else { return }
                
        FavoritesManager.shared.removeFavorite(artObject: artObject)
        // Remove the art object from Core Data
//            CoreDataHelper.shared.removeArtObject(artObject: artObject)
        
        isFavorite = false
        updateFavoriteButton()
        // Here you should remove the artObject from your favorites list (e.g., UserDefaults, CoreData, etc.)
    }
    
    private func loadImage() {
        // Load image or set placeholder
        if let imageUrl = URL(string: artObject?.primaryImage ?? "") {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(named: "placeholderImage") // Replace with your placeholder image name
                    }
                    print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
        } else {
            self.imageView.image = UIImage(named: "placeholderImage") // Replace with your placeholder image name
        }
    }
    
    


    
    
}

