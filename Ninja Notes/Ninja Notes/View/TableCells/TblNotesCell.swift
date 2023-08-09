//
//  TblNotesCell.swift
//  Ninja Notes
//
//  Created by Apple on 29/07/23.
//

import UIKit

class TblNotesCell: UITableViewCell {

    @IBOutlet private weak var cellContainerView:UIView!
    
    @IBOutlet private weak var imgUserImageView:UIImageView!
    @IBOutlet private weak var lblTitle:UILabel!
    @IBOutlet private weak var lblSubTitle:UILabel!
    @IBOutlet private weak var btnFavourite:UIButton!
    
    var note:DBNote = DBNote() {
        didSet{
            if let data = note.noteAvatar {
                imgUserImageView.image = UIImage(data: data)
            }else{
                imgUserImageView.image = UIImage(systemName: "person.crop.circle") ?? UIImage()
            }
            lblTitle.text = note.title ?? ""
            lblSubTitle.text = note.subTitle ?? ""
            
            if !ofTypeTrash {
                if (note.isFavorite ?? false){
                    btnFavourite.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }else{
                    btnFavourite.setImage(UIImage(systemName: "star"), for: .normal)
                }
            }else{
                btnFavourite.setImage(UIImage(systemName: "arrow.clockwise.circle"), for: .normal)
            }
           
            isFavourite = note.isFavorite ?? false
            isDeleted = note.isDeleted ?? false
        }
    }
    var isFavourite:Bool = false {
        didSet{
            if !ofTypeTrash {
                if (note.isFavorite ?? false){
                    btnFavourite.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }else{
                    btnFavourite.setImage(UIImage(systemName: "star"), for: .normal)
                }
            }else{
                btnFavourite.setImage(UIImage(systemName: "arrow.clockwise.circle"), for: .normal)
            }
        }
    }
    var isDeleted = false
    var ofTypeTrash = false {
        didSet{
            btnFavourite.setImage(UIImage(systemName: "arrow.clockwise.circle"), for: .normal)
        }
    }
    var didRestoreNote : ( () -> () ) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContainerView.layer.borderColor = UIColor.black.cgColor
        cellContainerView.layer.borderWidth = 1.25
    }
    
    @IBAction private func setFavourite(_ sender:UIButton){
        if ofTypeTrash{
            note.isDeleted = false
            DBHelper.setUnsetDeleteNote(id: (note.id ?? UUID()), isDeleted: !(note.isDeleted ?? false))
            self.didRestoreNote()
            
        }else{
            note.isFavorite = !(note.isFavorite ?? false)
            isFavourite = (note.isFavorite ?? false)
            DBHelper.setUnsetFavoriteNote(id: note.id ?? UUID(), isfavorite: (note.isFavorite ?? false))
        }
    }

}
