//
//  Coredata+Helper.swift
//  NASAPictureOfTheDay
//
//  Created by Raju K on 01/02/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    
    //MARK: Save and fetch offline records
    static func createData(picInfo: PictureOfTheDay, imageData: Data) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext

        //reate an entity and new user records.
        let savedPictureEntity = NSEntityDescription.entity(forEntityName: "SavedPictureModel", in: managedContext)!
        
        // add data to our newly created record
        let savedPicture = NSManagedObject(entity: savedPictureEntity, insertInto: managedContext)
        savedPicture.setValue(picInfo.title, forKey: "title")
        savedPicture.setValue(picInfo.explanation, forKey: "explaination")
        savedPicture.setValue(picInfo.date, forKey: "date")
        savedPicture.setValue(picInfo.url, forKey: "url")
        savedPicture.setValue(imageData, forKey: "imageData")
        
        do {
            try managedContext.save()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }





    static func retrieveSavedData()->[SavedPictureModel]{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}

        //create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext

        //Prepare the request of type NSFetchRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedPictureModel")
        do {
            let result = try managedContext.fetch(fetchRequest) as! [SavedPictureModel]
            return result
        } catch {
            print("Failed")
        }
        return []
    }


    static func retrieveData(forDate date: String) -> SavedPictureModel? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedPictureModel")
        fetchRequest.predicate = NSPredicate(format: "date = %@", date)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count > 0 {
                return result[0] as? SavedPictureModel
            }
        } catch {
            print("Failed")
        }
        return nil
    }

}
