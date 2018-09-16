//
//  Colors.swift
//  BibleApp
//
//  Created by Min Kim on 8/25/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

enum MainColor {
    static let redOrange = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
    static let blue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    static let purple = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0)
    static let green = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
    static let lightBlue = UIColor(red: 66/255, green: 209/255, blue: 244/255, alpha: 1.0)
}

extension UserDefaults {
    
    func color(forKey key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func set(_ value: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = value {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
    
}
