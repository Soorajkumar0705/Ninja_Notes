//
//  TrashVC.swift
//  Ninja Notes
//
//  Created by Apple on 30/07/23.
//

import UIKit

class TrashVC: BaseViewController {

    @IBOutlet private weak var imgSearchBar:UIImageView!
    @IBOutlet private weak var txtSearchBar:UITextField!
    
    @IBOutlet private weak var tblNotes:UITableView!
    @IBOutlet private weak var imgNoNotes:UIImageView!
    
    private var restoreClosure : ( () -> () ) = {}
    var notesData:[DBNote] = [] {
        didSet{
            didUpdateData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTblNotes()
        notesData = DBHelper.getDeletedNotes()
        
    }
    private func configureTblNotes(){
        tblNotes.delegate = self
        tblNotes.dataSource = self
        tblNotes.register(UINib(nibName: "TblTrashCells", bundle: nil), forCellReuseIdentifier: "TblTrashCells")
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
extension TrashVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblNotes.dequeueReusableCell(withIdentifier: "TblTrashCells",for: indexPath) as? TblTrashCells else { return UITableViewCell() }
        
        cell.note = notesData[indexPath.row]
        cell.restoreClosure = {
            self.deleteTableCells(tableView: tableView, indexPath: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/8
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        DBHelper.deleteNote(id:notesData[indexPath.row].id ?? UUID())
        notesData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}
extension TrashVC : UITableViewDelegate{

    private func deleteTableCells(tableView:UITableView ,indexPath:IndexPath){
        tableView.beginUpdates()
        self.notesData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
}
