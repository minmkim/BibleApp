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
        bottomContainerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomContainerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomContainerView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        indexList.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        indexList.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: -12).isActive = true
        indexList.widthAnchor.constraint(equalToConstant: 25).isActive = true
        setDominantHandIndexLayout()
        
        bookTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        bookTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bookTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bookTableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
    }
}
