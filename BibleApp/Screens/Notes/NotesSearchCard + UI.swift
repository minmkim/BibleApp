//
//  NotesSearchCard + UI.swift
//  BibleApp
//
//  Created by Min Kim on 10/29/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

extension NotesSearchCard {
    
    func layoutViews() {
        handleBar.centerXAnchor.constrain(to: view.centerXAnchor)
        handleBar.topAnchor.constrain(to: view.topAnchor, with: 12)
        handleBar.heightAnchor.constrain(to: 4)
        handleBar.widthAnchor.constrain(to: 60)
        
        cardSearchBar.centerXAnchor.constrain(to: view.centerXAnchor)
        cardSearchBar.topAnchor.constrain(to: handleBar.bottomAnchor, with: 8)
        cardSearchBar.heightAnchor.constrain(to: 50)
        cardSearchBar.widthAnchor.constrain(to: view.widthAnchor)
        
        searchTableView.topAnchor.constrain(to: cardSearchBar.bottomAnchor, with: 16)
        searchTableView.leadingAnchor.constrain(to: view.leadingAnchor)
        searchTableView.trailingAnchor.constrain(to: view.trailingAnchor)
        searchTableView.bottomAnchor.constrain(to: view.bottomAnchor)
    }
}
