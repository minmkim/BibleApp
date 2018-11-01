//
//  SavedVerseView + UI.swift
//  BibleApp
//
//  Created by Min Kim on 10/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension SavedVerseViewController {
    
    func layoutViews() {
        containerView.fillContainer(for: view)
        savedVerseTableView.fillContainer(for: containerView)
        
        actionBar.widthAnchor.constrain(to: view.widthAnchor)
        actionBar.heightAnchor.constrain(to: 40)
        actionBar.leadingAnchor.constrain(to: view.leadingAnchor)
        actionBarTopAnchor = actionBar.topAnchor.constrain(to: view.bottomAnchor, with: -40)
        actionBarTopAnchor?.isActive = true
    }
    
}
