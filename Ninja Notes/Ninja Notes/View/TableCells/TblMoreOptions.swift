//
//  TblMoreOptions.swift
//  Ninja Notes
//
//  Created by Apple on 30/07/23.
//

import UIKit

class TblMoreOptions: UITableViewCell {

    @IBOutlet private weak var cellContainerView:UIView!
    @IBOutlet private weak var imgViewCell:UIImageView!
    @IBOutlet private weak var lblCell:UILabel!
    
    var imgCell = UIImage() {
        didSet{
            self.imgViewCell.image = imgCell
        }
    }
    var txtlabel:String = ""{
        didSet{
            self.lblCell.text = txtlabel
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        cellContainerView.layer.borderColor = UIColor.black.cgColor
//        cellContainerView.layer.borderWidth = 0.5
    }
    
}
