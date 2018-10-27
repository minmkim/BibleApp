//
//  BookTableController + UI.swift
//  BibleApp
//
//  Created by Min Kim on 10/21/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

extension BookTableController {
    
    func layoutViews() {
        bottomContainerView.bottomAnchor.constrain(to: view.safeAreaLayoutGuide.bottomAnchor)
        bottomContainerView.leadingAnchor.constrain(to: view.safeAreaLayoutGuide.leadingAnchor)
        bottomContainerView.trailingAnchor.constrain(to: view.safeAreaLayoutGuide.trailingAnchor)
        bottomContainerView.heightAnchor.constrain(to: 36)
        
        indexList.topAnchor.constrain(to: view.safeAreaLayoutGuide.topAnchor, with: 12)
        indexList.bottomAnchor.constrain(to: bottomContainerView.topAnchor, with: -12)
        indexList.widthAnchor.constrain(to: 25)
        
        bookTableView.topAnchor.constrain(to: view.safeAreaLayoutGuide.topAnchor)
        bookTableView.leadingAnchor.constrain(to: view.safeAreaLayoutGuide.leadingAnchor)
        bookTableView.trailingAnchor.constrain(to: view.safeAreaLayoutGuide.trailingAnchor)
        bookTableView.bottomAnchor.constrain(to: bottomContainerView.topAnchor)
    }
}
