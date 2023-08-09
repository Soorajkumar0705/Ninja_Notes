//
//  CDHelper.swift
//  Ninja Notes
//
//  Created by Apple on 26/07/23.
//

import CoreData

class CDHelper{
    
    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Ninja_Notes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    //MARK: - Core Data Context
    
    static func getContext() -> NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    // MARK: - Core Data Saving support

   static func saveContext () {
       let context = self.getContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Notes Operation funcs
    
    class func saveNote(note:DBNote){
        let context = CDHelper.getContext()
        
        let cdNote = NSEntityDescription.insertNewObject(forEntityName: "CDNote", into: context) as! CDNote
        
        cdNote.noteId = note.id
        cdNote.title = note.title
        cdNote.subTitle = note.subTitle
        cdNote.noteDescription = note.noteDescription
        cdNote.noteAvatar = note.noteAvatar
        cdNote.createdAt = note.createdAt
        cdNote.updatedAt = note.updatedAt
        cdNote.isFavorite = note.isFavorite ?? false
        cdNote.isdeleted = note.isDeleted ?? false
 
        do{
            try context.save()
        }catch let error{
            print("Error while saving Note ",error)
        }
        
    }
    class func updateNote(note:DBNote){
        let context = CDHelper.getContext()
        guard let id = note.id else{ return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDNote")
        fetchRequest.predicate = NSPredicate(format: "noteId == %@", id as CVarArg)
        
        do{
            let fetchedCDNotes = try context.fetch(fetchRequest) as? [CDNote] ?? []
            if let cdNote = fetchedCDNotes.first{
                
                cdNote.title = note.title
                cdNote.subTitle = note.subTitle
                cdNote.noteDescription = note.noteDescription
                cdNote.noteAvatar = note.noteAvatar
                cdNote.createdAt = note.createdAt
                cdNote.updatedAt = note.updatedAt
                cdNote.isFavorite = note.isFavorite ?? false
                cdNote.isdeleted = note.isDeleted ?? false
         
            }
        }catch let error{
            print("Error while fetching Note ",error)
        }
    }
    
    class func getNoteFromId(id:UUID) -> CDNote? {
        let context = CDHelper.getContext()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDNote")
        fetchRequest.predicate = NSPredicate(format: "noteId == %@", id as CVarArg)
        
        do{
            let fetchedCDNotes = try context.fetch(fetchRequest) as? [CDNote] ?? []
            if let cdNote = fetchedCDNotes.first{
                return cdNote
            }
        }catch let error{
            print("Error while fetching Note ",error)
        }
        return nil
    }
    class func getNoteBySearchText(sText:String) -> [CDNote]{
        let context = CDHelper.getContext()
        var searchResult:[CDNote] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDNote")
        fetchRequest.predicate = NSPredicate(format: "title contains %@",sText)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        do{
            let fetchedResults = try context.fetch(fetchRequest) as? [CDNote] ?? []
            searchResult.append(contentsOf: fetchedResults)
            
        }catch let error{
            print("Error while fetching serach note record ",error)
        }
        return searchResult
    }
    class func getAllUndeletedNotes() -> [CDNote]{
        let context = CDHelper.getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDNote")
        fetchRequest.predicate = NSPredicate(format: "isdeleted == %@",NSNumber(value: false))
        
        do{
            return try context.fetch(fetchRequest) as? [CDNote] ?? []
        }catch let error{
            print("Error while fetching favorite Note ",error)
        }
    
        return []
    }
    
    class func getFavoriteNotes() -> [CDNote] {
        let context = CDHelper.getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDNote")
        let pred1 = NSPredicate(format: "isFavorite == %@",NSNumber(value: true))
        let pred2 = NSPredicate(format: "isdeleted == %@", NSNumber(value: false))
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pred1,pred2])
        
        do{
            return try context.fetch(fetchRequest) as? [CDNote] ?? []
        }catch let error{
            print("Error while fetching favorite Note ",error)
        }
    
        return []
    }
    
    class func getDeletedNotes() -> [CDNote] {
        let context = CDHelper.getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDNote")
        fetchRequest.predicate = NSPredicate(format: "isdeleted == %@",NSNumber(value: true))
        
        do{
            return try context.fetch(fetchRequest) as? [CDNote] ?? []
        }catch let error{
            print("Error while fetching favorite Note ",error)
        }
    
        return []
    }
    
    class func setUnsetIsFavorite(id: UUID, isFavorite:Bool){
        let context = CDHelper.getContext()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDNote")
        fetchRequest.predicate = NSPredicate(format: "noteId == %@", id as CVarArg)
        
        do{
            let fetchedCDNotes = try context.fetch(fetchRequest) as? [CDNote] ?? []
            if let cdNote = fetchedCDNotes.first{
                cdNote.isFavorite = isFavorite
                
                try context.save()
            }
        }catch let error{
            print("Error while fetching favorite Note ",error)
        }
        
    }
    
    class func setUnsetDeletedNotes(id: UUID,isDeleted:Bool){
        let context = CDHelper.getContext()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDNote")
        fetchRequest.predicate = NSPredicate(format: "noteId == %@", id as CVarArg)
        
        do{
            let fetchedCDNotes = try context.fetch(fetchRequest) as? [CDNote] ?? []
            if let cdNote = fetchedCDNotes.first{
                cdNote.isdeleted = isDeleted
                if isDeleted{
                    cdNote.deletedDate = (String.timeStamp().toDate() ?? Date())
                }
                
                try context.save()
            }
        }catch let error{
            print("Error while fetching favorite Note ",error)
        }
    }
    class func deleteNote(noteId:UUID){
        let context = CDHelper.getContext()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDNote")
        fetchRequest.predicate = NSPredicate(format: "noteId == %@", noteId as CVarArg)
        
        do{
            let fetchedCDNotes = try context.fetch(fetchRequest) as? [CDNote] ?? []
            if let cdNote = fetchedCDNotes.first{
                context.delete(cdNote)
            }
            try context.save()
            
        }catch let error{
            print("Error while fetching and Deleting  Note ",error)
        }
    }
}
