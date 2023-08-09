//
//  BaseViewController.swift
//  Ninja Notes
//
//  Created by Apple on 26/07/23.
//

import UIKit

class BaseViewController : UIViewController{
    
    
    private var backButtun:UIButton = UIButton()
    private var bgImageView:UIImageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor._00E9D3
        self.navigationController?.isNavigationBarHidden = true
        configureBackButton()
        configureBGImage()
        hideBGImage()
    }
    
    private func configureBackButton(){
        self.view.addSubview(backButtun)
        backButtun.frame = CGRect(x: 30, y: 60, width: 45, height: 45)
        backButtun.layer.cornerRadius = 13
        backButtun.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        backButtun.imageView?.contentMode = .scaleAspectFit
        backButtun.tintColor = UIColor.white
        backButtun.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButtun.addTarget(self, action: #selector(backButtontarget(_ :)), for: .touchUpInside)
    }
    private func configureBGImage(){
        self.view.insertSubview(bgImageView, at: 1)
//        self.view.addSubview(bgImageView)
        bgImageView.alpha = 0.7
        bgImageView.image = UIImage.bg
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.tintColor = UIColor.black
        bgImageView.frame = CGRect(x: 0, y: 0,
                                   width: self.view.frame.width - 40,
                                   height: self.view.frame.width - 40)
        bgImageView.center = self.view.center
       
        
    }
     func configureBackTapGesture(){
        let backTap = UITapGestureRecognizer(target: self,
                                             action: #selector(endEditing(_ :)))
        self.view.addGestureRecognizer(backTap)
    }
}
extension BaseViewController{
    
    func hideBackbutton(){
        self.backButtun.isHidden = true
    }
    func hideBGImage(){
        self.bgImageView.isHidden = true
    }
    func push(in fromVC:UIViewController, to VcId:VC, animated:Bool = true, passData:((Any) -> ())?){
        let toVC = fromVC.storyboard?.instantiateViewController(withIdentifier: VcId.rawValue)
        fromVC.navigationController?.pushViewController(toVC!, animated: animated)
        passData?(toVC as Any)
    }
    func pop(animated:Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }
    @objc private func backButtontarget(_ sender: UIButton){
        self.pop()
    }
    
    @objc private func endEditing(_ gesture:UITapGestureRecognizer){
        if let _ = gesture.view{
            print(#function)
            self.view.endEditing(true)
        }
    }
}
//MARK: - Enum VC

enum VC : String{
    case HomeVC = "HomeVC"
    case NewNoteVC = "NewNoteVC"
    case NoteDetailsVC = "NoteDetailsVC"
    case FavouritesVC = "FavouritesVC"
    case TrashVC = "TrashVC"
    case SettingsVC = "SettingsVC"
    case AboutUs = "AboutUs"
}
