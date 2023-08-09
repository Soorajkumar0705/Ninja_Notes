//
//  ViewController.swift
//  Ninja Notes
//
//  Created by Apple on 26/07/23.
//

import UIKit

class HomeVC: BaseViewController {
    
    @IBOutlet private weak var btnMoreOptions:CustomButton!
    @IBOutlet private weak var btnAddNewNotes:CustomButton!
    
    @IBOutlet private weak var imgSearchBar:UIImageView!
    @IBOutlet private weak var txtSearchBar:UITextField!
    
    @IBOutlet private weak var noNotesImg:UIImageView!
    @IBOutlet private weak var tblNotes:UITableView!
    @IBOutlet private weak var stkNoNotesLabel:UIStackView!
    
    @IBOutlet private weak var tblMoreOptions:UITableView!
    @IBOutlet private weak var moreOptionViewWidth:NSLayoutConstraint!
    @IBOutlet private weak var imgHideMoreOptionsTable:UIImageView!
    
    var notesData : [DBNote] = [] {
        didSet{
            didUpdateData()
        }
    }
    var moreOptionsStringData:[String] = ["Favourites","Trash","Settings","AboutUs"]
    var moreOptionsImageString:[UIImage] = [UIImage.favourites,UIImage.trash,UIImage.settings,UIImage.aboutUs]
    
    var isMoreOptionsEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTblNotes()
        configureTblMoreOptions()
        updateUI()
        configureSearchBarImageTapGesture()
        configureBacktapGesture()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesData = DBHelper.getAllUndeletedNotes()
    }
    
    private func updateUI(){
        hideBackbutton()
        self.view.backgroundColor = .white
        txtSearchBar.delegate = self
        tblMoreOptions.superview?.layer.cornerRadius = 20
        tblMoreOptions.superview?.layer.borderColor = UIColor.black.cgColor
        noNotesImg.superview?.isUserInteractionEnabled = true
    }
    
    private func configureSearchBarImageTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(searchBarImageTapped(_ :)))
        imgSearchBar.isUserInteractionEnabled = true
        imgSearchBar.addGestureRecognizer(tapGesture)
    }
    
    private func configureBacktapGesture(){
        let backTap = UITapGestureRecognizer(target: self, action: #selector(endEditingView(_ :)))
        backTap.delegate = self
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(backTap)
        
        let hideMoreOptionTableGesture = UITapGestureRecognizer(target: self, action: #selector(hideMoreOptionsTable(_ :)))
        
        imgHideMoreOptionsTable.isUserInteractionEnabled = true
        imgHideMoreOptionsTable.addGestureRecognizer(hideMoreOptionTableGesture)
    }

    private func configureTblNotes(){
        tblNotes.delegate = self
        tblNotes.dataSource = self
        tblNotes.register(UINib(nibName: "TblNotesCell", bundle: nil), forCellReuseIdentifier: "TblNotesCell")
    }
    private func configureTblMoreOptions(){
        tblMoreOptions.delegate = self
        tblMoreOptions.dataSource = self
        tblMoreOptions.register(UINib(nibName: "TblMoreOptions", bundle: nil), forCellReuseIdentifier: "TblMoreOptions")
    }
    
    private func didUpdateData(){
        
        if notesData.count == 0{
            tblNotes.isHidden = true
            noNotesImg.isHidden = false
            noNotesImg.superview?.isUserInteractionEnabled = false
            stkNoNotesLabel.isHidden = false
            
        }else {
            tblNotes.isHidden = false
            noNotesImg.isHidden = true
            noNotesImg.superview?.isUserInteractionEnabled = true
            stkNoNotesLabel.isHidden = true
            tblNotes.reloadData()
        }
    }
    
    private func setSearchBarImage(_ value:Bool){
        if value{
            imgSearchBar.image = UIImage.magnifyingglass
        }else{
            imgSearchBar.image = UIImage.cross
        }
    }
}

extension HomeVC{
    
    @IBAction private func moreOptionsTapped(_ sender:CustomButton){
        self.view.endEditing(true)
        showMoreOptionsTable()
    }
    
    @IBAction private func newNotesTapped(_ sender:CustomButton){
        self.view.endEditing(true)
        push(in: self, to: VC.NewNoteVC, passData: nil)
    }
    @objc private func searchBarImageTapped(_ gesture:UITapGestureRecognizer){
        print(#function)
        if let imgView = gesture.view as? UIImageView{
         
            if imgView.image == UIImage.cross{
                txtSearchBar.text = ""
               setSearchBarImage(true)
                self.notesData = DBHelper.getAllUndeletedNotes()
            }else{
                self.notesData = DBHelper.getBySearchText(sText: txtSearchBar.text ?? "")
            }
        }
    }
    
    
    @objc private func endEditingView(_ gesture:UITapGestureRecognizer){
        self.view.endEditing(true)
        hideMoreOptionsTable()
    }
    
    @objc private func hideMoreOptionsTable(_ gesture:UITapGestureRecognizer){
        self.view.endEditing(true)
        hideMoreOptionsTable()
    }
    
    // MARK: - Show Hide More Options Table
    private func showMoreOptionsTable(){
        self.isMoreOptionsEnabled = true
        self.moreOptionViewWidth.constant = (self.view.frame.width)*0.7
        
        UIView.animate(withDuration: 0.3) {
            self.tblMoreOptions.superview?.layer.borderWidth = 2
            self.tblMoreOptions.superview?.alpha = 1
        }completion: { _  in
        }
    }
    private func hideMoreOptionsTable(){
        self.isMoreOptionsEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.tblMoreOptions.superview?.layer.borderWidth = 0
            self.tblMoreOptions.superview?.alpha = 0.01
        }completion: { _ in
            self.moreOptionViewWidth.constant = 0
        }
    }
}
extension HomeVC:UITextFieldDelegate,UIGestureRecognizerDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setSearchBarImage((textField.text ?? "").count == 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text ?? "").count == 0 {
            setSearchBarImage(true)
            self.notesData = DBHelper.getAllUndeletedNotes()
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: view)
        let result = tblMoreOptions.superview?.frame.contains(point) ?? true || tblNotes.frame.contains(point)
        return !(result)
    }
}

extension HomeVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView{
        case tblNotes:
            return UIScreen.main.bounds.height/8
            
        case tblMoreOptions:
            return 75
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case tblNotes:
            return notesData.count
            
        case tblMoreOptions:
            return moreOptionsStringData.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case tblNotes:
            guard let cell = tblNotes.dequeueReusableCell(withIdentifier: "TblNotesCell", for: indexPath) as? TblNotesCell else { return UITableViewCell() }
            cell.note = self.notesData[indexPath.row]
            
            return cell
        case tblMoreOptions:
            guard let cell = tblMoreOptions.dequeueReusableCell(withIdentifier: "TblMoreOptions", for: indexPath) as? TblMoreOptions else { return UITableViewCell() }
            
            cell.imgCell = moreOptionsImageString[indexPath.row]
            cell.txtlabel = moreOptionsStringData[indexPath.row]
            
            return cell
        default :
            return UITableViewCell()
        }
  
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        DBHelper.setUnsetDeleteNote(id: self.notesData[indexPath.row].id ?? UUID(), isDeleted: true)
        self.notesData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let act = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
//
//            print("Deleted at ",indexPath)
//
//        }
//        act.image = UIImage(systemName: "trash.fill")
//        return UISwipeActionsConfiguration(actions: [act])
//    }

}

extension HomeVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case tblNotes:
            push(in: self, to: VC.NoteDetailsVC) { vc in
                if let vc = vc as? NoteDetailsVC{
                    vc.noteDetails = self.notesData[indexPath.row]
                }
            }
        case tblMoreOptions:
            tblMoreOptionsNavigation(indexPath: indexPath)
        default:
            print(indexPath)

        }
    }
    
    private func tblMoreOptionsNavigation(indexPath:IndexPath){
        hideMoreOptionsTable()
        switch indexPath.row {
        case 0:
            push(in: self, to: VC.FavouritesVC, passData: nil)
            
        case 1:
            push(in: self, to: VC.TrashVC) { vc in
                if let vc = vc as? TrashVC {
                    
                }
            }

        case 2:
            push(in: self, to: VC.SettingsVC, passData: nil)

        case 3:
            push(in: self, to: VC.AboutUs, passData: nil)

        default:
            print(indexPath)
            
        }
    }
}
