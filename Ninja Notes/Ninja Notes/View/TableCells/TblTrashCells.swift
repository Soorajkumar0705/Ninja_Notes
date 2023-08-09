//
//  TblTrashCells.swift
//  Ninja Notes
//
//  Created by Apple on 31/07/23.
//

import UIKit

class TblTrashCells: UITableViewCell {

    @IBOutlet private weak var cellContainerView:UIView!
    
    @IBOutlet private weak var imgUserImageView:UIImageView!
    @IBOutlet private weak var lblTitle:UILabel!
    @IBOutlet private weak var lblSubTitle:UILabel!
    @IBOutlet private weak var btnRestore:UIImageView!
    
    var note:DBNote = DBNote() {
        didSet{
            if let data = note.noteAvatar {
                imgUserImageView.image = UIImage(data: data)
            }else{
                imgUserImageView.image = UIImage(systemName: "person.crop.circle") ?? UIImage()
            }
            lblTitle.text = note.title ?? ""
            lblSubTitle.text = note.subTitle ?? ""
            btnRestore.image = UIImage.restore
        }
    }
    
//    var restore:Bool = false
    var restoreClosure : ( () -> () ) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContainerView.layer.borderColor = UIColor.black.cgColor
        cellContainerView.layer.borderWidth = 1.25
        btnRestore.contentMode = .scaleToFill
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(restoreNote(_ :)))
        btnRestore.isUserInteractionEnabled = true
        btnRestore.addGestureRecognizer(tap)
    }
    
    @objc private func restoreNote(_ gesture:UITapGestureRecognizer){
        self.restoreClosure()
        DBHelper.setUnsetDeleteNote(id: (note.id ?? UUID()), isDeleted: !(note.isDeleted ?? false))
    }
}
