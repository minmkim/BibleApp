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
        savedVerseTableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        savedVerseTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        savedVerseTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        savedVerseTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        actionBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        actionBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        actionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        actionBarTopAnchor = actionBar.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        actionBarTopAnchor?.isActive = true
    }
    
}
