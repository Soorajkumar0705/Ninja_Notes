//
//  NewNoteVC.swift
//  Ninja Notes
//
//  Created by Apple on 30/07/23.
//

import UIKit

class NewNoteVC: BaseViewController {

    @IBOutlet private weak var userImage:UIImageView!
    @IBOutlet private weak var plusImage:UIImageView!
    
    @IBOutlet private weak var txtTitle:UITextField!
    @IBOutlet private weak var txtSubTitle:UITextField!
    @IBOutlet private weak var txtDescription:UITextView!
    @IBOutlet private      var txtGrp:[UITextField]!
    
    @IBOutlet private weak var btnSave:UIButton!
    
    var note:DBNote = DBNote()
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackTapGesture()
        updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isUpdate {
            hideBackbutton()
            showNoteForUpdate()
            btnSave.setTitle("Update", for: .normal)
        }else{
            plusImage.isHidden = false
            btnSave.setTitle("Save", for: .normal)
        }
    }
    private func updateUI(){
        
        let userImagePickerGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageFromPicker(_ :)))
        userImage.isUserInteractionEnabled = true
        userImage.contentMode = .scaleToFill
        userImage.addGestureRecognizer(userImagePickerGesture)
        userImage.layer.cornerRadius = userImage.frame.height/2
        
        for txt in txtGrp{
            txt.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            txt.attributedText = addAttributesToTheString(string: txt.placeholder ?? "")
            txt.delegate = self
        }
        txtDescription.delegate = self
        txtDescription.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        txtDescription.attributedText = addAttributesToTheString(string: txtDescription.text ?? "")
        
        btnSave.layer.cornerRadius = 10
        btnSave.layer.borderColor = UIColor.black.cgColor
        btnSave.layer.borderWidth = 1.5
    }
    private func addAttributesToTheString(string:String) -> NSAttributedString{
        let attribute = [NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrStr = NSAttributedString(string: string,attributes: attribute)
        return attrStr
    }
    
    
    private func showNoteForUpdate(){
        if let data = note.noteAvatar {
            userImage.image = UIImage(data: data)
        }
        txtTitle.text = note.title ?? "title"
        txtSubTitle.text = note.subTitle ?? "subTitle"
        txtDescription.text = note.noteDescription ?? "Description"
    }
    
    private func createNewNote(){
        var note = DBNote()
        
        note.id = UUID()
        note.title = txtTitle.text ?? "title"
        note.subTitle = txtSubTitle.text ?? "subTitle"
        note.noteDescription = txtDescription.text ?? "Description"
        note.createdAt = String.timeStamp().toDate() ?? Date()
        note.updatedAt = String.timeStamp().toDate() ?? Date()
        note.isFavorite = false
        note.isDeleted = false
        if let img = userImage.image{
            note.noteAvatar = img.pngData()
        }
        
        DBHelper.saveNote(note: note)
        
    }
    private func updateExistingNote(){
        var updatedNote = DBNote()
        
        updatedNote.id = note.id
        updatedNote.title = txtTitle.text ?? "title"
        updatedNote.subTitle = txtSubTitle.text ?? "subTitle"
        updatedNote.noteDescription = txtDescription.text ?? "Description"
        updatedNote.createdAt = note.createdAt
        updatedNote.updatedAt = (String.timeStamp().toDate() ?? Date())
        updatedNote.isFavorite = false
        updatedNote.isDeleted = false
        
        if let img = userImage.image{
            note.noteAvatar = img.pngData()
        }
        
        DBHelper.updateNote(note: note)
    }
}
extension NewNoteVC {
    @IBAction private func saveNoteTapped(_ sender:UIButton){
        if isUpdate {
            updateExistingNote()
            self.dismiss(animated: true, completion: nil)
        }else{
            createNewNote()
            pop()
        }
    }
    @objc private func selectImageFromPicker(_ gesture:UITapGestureRecognizer){
        
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = .photoLibrary
        self.present(imageController, animated: true)

    }
}
extension NewNoteVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let image = img{
            self.userImage.image = img
        }
        self.dismiss(animated: true)
        self.plusImage.isHidden = true
    }
}
extension NewNoteVC : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if( textField.text ?? "").isEmpty || (textField.text ?? "") == "" {
            switch textField{
                
            case txtTitle:
                txtTitle.text = "Enter Notes Title ."
                
            case txtSubTitle:
                txtSubTitle.text = "Enter Notes SubTitle ."
                
            default :
                print("")
            }
        }
    }
}
extension NewNoteVC : UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtDescription.text.isEmpty || txtDescription.text == "" {
            txtDescription.textColor = .lightGray
            txtDescription.text = "Enter Note Description ."
        }
    }
}
