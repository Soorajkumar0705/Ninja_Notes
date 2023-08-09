//
//  Model.swift
//  Ninja Notes
//
//  Created by Apple on 26/07/23.
//

import Foundation

struct DBNote{
    
    var id: UUID?
    var title: String?
    var subTitle: String?
    var noteDescription: String?
    var noteAvatar:Data?
    var createdAt: Date?
    var updatedAt:Date?
    var isFavorite: Bool?
    var isDeleted: Bool?
    
   static func initClass(id:UUID?, title:String?, subTitle:String?,
                         description:String?,noteAvatar:Data?,createdAt:Date?,updatedAt:Date?,
         isFavorite:Bool?,isDeleted:Bool?) -> DBNote{
       var note = DBNote()
       
       note.id = id
       note.title = title
       note.subTitle = subTitle
       note.noteDescription = description
       note.noteAvatar = noteAvatar
       note.createdAt = createdAt
       note.updatedAt = updatedAt
       note.isFavorite = isFavorite
       note.isDeleted = isDeleted
       
       return note
    }
  
}

extension CDNote{
    
    func convertToDB() -> DBNote{
        var note = DBNote()
        
        note.id = self.noteId ?? UUID()
        note.title = self.title
        note.subTitle = self.title
        note.noteDescription = self.noteDescription
        note.noteAvatar = self.noteAvatar
        note.createdAt = (self.createdAt ?? Date())
        note.updatedAt = (self.updatedAt ?? Date())
        note.isFavorite = self.isFavorite
        note.isDeleted = self.isdeleted
        
        return note
    }
    
    func convertToDB(cdNotes:[CDNote]) -> [DBNote]{
        return cdNotes.compactMap { $0.convertToDB() }
    }
   
}
