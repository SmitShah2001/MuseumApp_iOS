//
//  ViewController.swift
//  MuseumApp
//
//  Created by user247453 on 8/10/24.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {


    
    
    @IBOutlet weak var museumTableView: UITableView!
    

    
    
    
    var artObjects: [ArtObject] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        museumTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ArtObjectCell")
           
        
        print("viewDidLoad called")
        
        museumTableView.dataSource = self
        museumTableView.delegate = self
                fetchArtObjects()
    }


    
    func fetchArtObjects() {
            print("Fetching art objects...")

            // Step 1: Fetch objectIDs
            NetworkManager.shared.fetchObjectIDs { [weak self] objectIDs in
                guard let self = self, let objectIDs = objectIDs else {
                    print("No objectIDs received")
                    return
                }
                
                // Step 2: Fetch details for each objectID
                self.fetchArtObjectsDetails(objectIDs: objectIDs)
            }
        }
    
    func fetchArtObjectsDetails(objectIDs: [Int]) {
            let dispatchGroup = DispatchGroup()
            
            for objectID in objectIDs.prefix(100) { // Limiting to 10 items for demo
                dispatchGroup.enter()
                NetworkManager.shared.fetchArtObjectDetails(objectID: objectID) { [weak self] artObject in
                    if let artObject = artObject {
                        self?.artObjects.append(artObject)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                print("Fetched \(self.artObjects.count) art objects")
                            // Print all art objects to debug
                            self.artObjects.forEach { artObject in
                                print("ArtObject - ID: \(artObject.objectID), Title: \(artObject.title), Artist: \(artObject.artistDisplayName), Image URL: \(artObject.primaryImage)")
                            }
                            self.museumTableView.reloadData()}
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = artObjects.count
                print("Number of rows in section: \(count)")
                return count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtObjectCell", for: indexPath)
                    let artObject = artObjects[indexPath.row]
            
                    
                    print("Configuring cell for art object: \(artObject.title)")
                    
                    cell.textLabel?.text = artObject.title
                    cell.detailTextLabel?.text = artObject.artistDisplayName
                    return cell
        }

        // MARK: - UITableViewDelegate Methods

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
                    let selectedArtObject = artObjects[indexPath.row]
                    
                    print("Selected art object: \(selectedArtObject.title)")
                    
                    performSegue(withIdentifier: "toShowDetail", sender: selectedArtObject)
                }
        
    // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toShowDetail" {
                if let detailVC = segue.destination as? DetailsViewController {
                                detailVC.artObject = sender as? ArtObject
                                print("Preparing segue for DetailViewController")
                            }
            }
        }

}
