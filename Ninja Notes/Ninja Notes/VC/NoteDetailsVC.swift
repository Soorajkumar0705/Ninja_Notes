//
//  NoteDetailsVC.swift
//  Ninja Notes
//
//  Created by Apple on 30/07/23.
//

import UIKit

class NoteDetailsVC: BaseViewController {
    
    @IBOutlet private weak var imgUserImageView:UIImageView!
    @IBOutlet private weak var lblTitle:UILabel!
    @IBOutlet private weak var lblSubTitle:UILabel!
    @IBOutlet private weak var lblDescription:UITextView!
    @IBOutlet private weak var btnUpdateNote:UIButton!
    
    var noteDetails : DBNote = DBNote() {
        didSet{
            if imgUserImageView != nil{
                didUpdateData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didUpdateData()
    }
    
    private func didUpdateData(){
        if let data = noteDetails.noteAvatar {
            imgUserImageView.image = UIImage(data: data)
        }else{
            imgUserImageView.image = UIImage(systemName: "person.crop.circle") ?? UIImage()
        }
        lblTitle.text = noteDetails.title ?? ""
        lblSubTitle.text = noteDetails.subTitle ?? ""
        lblDescription.text = noteDetails.noteDescription ?? ""
    }
    
    @IBAction private func updateNoteTapped(_ sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: VC.NewNoteVC.rawValue) as! NewNoteVC
        vc.isUpdate = true
        vc.note = self.noteDetails
        self.present(vc, animated: true)
    }

}
