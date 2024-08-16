//
//  CoreDataHelper.swift
//  MuseumApp
//
//  Created by user247453 on 15/08/24.
//

import Foundation

import UIKit
import CoreData

class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MuseumApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addArtObject(artObject: ArtObject) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            let newArt = NSEntityDescription.insertNewObject(forEntityName: "ArtEntities", into: context)
            newArt.setValue(artObject.title, forKey: "title")
            newArt.setValue(artObject.primaryImage, forKey: "primaryImage")
            newArt.setValue(artObject.period, forKey: "period")
            newArt.setValue(artObject.objectDate, forKey: "objectDate")
            newArt.setValue(artObject.culture, forKey: "culture")
            newArt.setValue(artObject.country, forKey: "country")
            newArt.setValue(artObject.artistDisplayName, forKey: "artistDisplayName")
            
            
            
            
            try context.save()
            
            print("Saved artobject: \(artObject.title)")
        }
        catch{
            
        }
        
    }
    }
