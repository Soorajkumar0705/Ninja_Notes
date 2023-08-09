//
//  DBHelper.swift
//  Ninja Notes
//
//  Created by Apple on 26/07/23.
//

import CoreData


class DBHelper {

    class func saveNote(note:DBNote){
        CDHelper.saveNote(note: note)
    }
    class func updateNote(note:DBNote){
        CDHelper.updateNote(note:note)
    }
    class func getById(id:UUID) -> DBNote?{
       return CDHelper.getNoteFromId(id: id)?.convertToDB()
    }
    class func getBySearchText(sText:String) -> [DBNote]{
        return CDHelper.getNoteBySearchText(sText: sText).map { $0.convertToDB() }
    }
    class func getFavoriteNotes() -> [DBNote]{
        return CDHelper.getFavoriteNotes().compactMap({$0.convertToDB()})
    }
    class func getDeletedNotes() -> [DBNote]{
       return CDHelper.getDeletedNotes().compactMap({$0.convertToDB()})
    }
    class func getAllUndeletedNotes() -> [DBNote]{
       return CDHelper.getAllUndeletedNotes().compactMap({$0.convertToDB()})
    }
    
    class func setUnsetFavoriteNote(id:UUID, isfavorite: Bool){
        CDHelper.setUnsetIsFavorite(id: id, isFavorite: isfavorite)
    }
    class func setUnsetDeleteNote(id:UUID, isDeleted:Bool){
        CDHelper.setUnsetDeletedNotes(id: id, isDeleted: isDeleted)
    }
    class func deleteNote(id:UUID){
        CDHelper.deleteNote(noteId: id)
    }

    

}

