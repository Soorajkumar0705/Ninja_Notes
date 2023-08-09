//
//  FavouritesVC.swift
//  Ninja Notes
//
//  Created by Apple on 30/07/23.
//

import UIKit

class FavouritesVC: BaseViewController {

    @IBOutlet private weak var imgSearchBar:UIImageView!
    @IBOutlet private weak var txtSearchBar:UITextField!
    
    @IBOutlet private weak var tblNotes:UITableView!
    @IBOutlet private weak var imgNoNotes:UIImageView!
    
    var notesData:[DBNote] = [] {
        didSet{
            didUpdateData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTblNotes()
        notesData = DBHelper.getFavoriteNotes()
        
    }
    private func configureTblNotes(){
        tblNotes.delegate = self
        tblNotes.dataSource = self
        tblNotes.register(UINib(nibName: "TblNotesCell", bundle: nil), forCellReuseIdentifier: "TblNotesCell")
    }
    private func didUpdateData(){
        tblNotes.reloadData()
        if notesData.count == 0 {
            tblNotes.isHidden = true
            imgNoNotes.isHidden = false
        }else{
            tblNotes.isHidden = false
            imgNoNotes.isHidden = true
        }
    }
}
extension FavouritesVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblNotes.dequeueReusableCell(withIdentifier: "TblNotesCell",for: indexPath) as? TblNotesCell else { return UITableViewCell() }
        
        cell.note = notesData[indexPath.row]
        cell.didRestoreNote = {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/8
    }
    
}
extension FavouritesVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(in: self, to: VC.NoteDetailsVC) { vc in
            if let vc = vc as? NoteDetailsVC{
                vc.noteDetails = self.notesData[indexPath.row]
            }
        }
    }
    
}
