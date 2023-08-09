//
//  SettingsVC.swift
//  Ninja Notes
//
//  Created by Apple on 30/07/23.
//

import UIKit

class SettingsVC: BaseViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view1.layer.borderColor = UIColor.black.cgColor
        view1.layer.borderWidth = 1.25
        view1.layer.cornerRadius = 5

        view2.layer.borderColor = UIColor.black.cgColor
        view2.layer.borderWidth = 1.25
        view2.layer.cornerRadius = 5

    }
  
    
}
