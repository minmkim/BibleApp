//
//  Theme.swift
//  BibleApp
//
//  Created by Min Kim on 8/29/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    
    var statusBarStyle: UIStatusBarStyle
    var barBackgroundColor: UIColor
    var barForegroundColor: UIColor
    var backgroundColor: UIColor
    var textColor: UIColor
    
}

extension Theme {
    
    static let light = Theme(
        statusBarStyle: .default,
        barBackgroundColor: .white,
        barForegroundColor: .black,
        backgroundColor: .white,
        textColor: .darkText
    )
    
    static let dark = Theme(
        statusBarStyle: .lightContent,
        barBackgroundColor: UIColor(white: 0, alpha: 1),
        barForegroundColor: .white,
        backgroundColor: .black,
        textColor: .lightText
    )
}

extension Notification.Name {
    static let darkModeEnabled = Notification.Name("com.minkim.BibleApp.notifications.darkModeEnabled")
    static let darkModeDisabled = Notification.Name("com.minkim.BibleApp.notifications.darkModeDisabled")
}
