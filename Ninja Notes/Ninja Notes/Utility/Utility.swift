//
//  Utility.swift
//  Ninja Notes
//
//  Created by Apple on 26/07/23.
//

import UIKit

extension UIColor{
    static var A0E86F:UIColor{
        return UIColor(named: "A0E86F") ?? UIColor.green
    }
    static var _00E9D3:UIColor{
        return UIColor(named: "00E9D3") ?? UIColor.cyan
    }
    
    static var ThemeBGColor:UIColor{
        return UIColor._00E9D3
    }
}
extension UIImage{
    
    static var noNotes:UIImage{
        return UIImage(named: "No Notes") ?? UIImage()
    }
    static var bg:UIImage{
        return UIImage(named: "bg") ?? UIImage()
    }
    static var magnifyingglass:UIImage{
        return UIImage(systemName: "magnifyingglass") ?? UIImage()
    }
    static var aboutUs:UIImage{
        return UIImage(systemName: "info.circle") ?? UIImage()
    }
    static var cross:UIImage{
        return UIImage(named: "Cross") ?? UIImage()
    }
    static var favourites:UIImage{
        return UIImage(named: "favourites") ?? UIImage()
    }
    static var liked:UIImage{
        return UIImage(named: "liked") ?? UIImage()
    }
    static var trash:UIImage{
        return UIImage(systemName: "trash") ?? UIImage()
    }
    static var settings:UIImage{
        return UIImage(named: "settings") ?? UIImage()
    }
    static var restore:UIImage{
        return UIImage(named: "restore") ?? UIImage()
    }
    
}


// Dates
extension Date{
     func timeStamp() -> Date{
        let date = String.timeStamp()
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
       return df.date(from: date) ?? Date()
    }
    func toString() -> String{
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return df.string(from: self)
    }
}
extension String{
    static func timeStamp() -> String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return df.string(from: date)
    }
     func toDate() -> Date?{
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return df.date(from: self)
    }
}
