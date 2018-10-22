//
//  BibleViewController + UI.swift
//  BibleApp
//
//  Created by Min Kim on 10/21/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension BibleViewController {
    
    func layoutViews() {
        topView.frame = CGRect(x: 0, y: -80, width: self.view.frame.width, height: 80)
        containerView.fillContainer(for: self.view)
        indexList.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        indexList.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        indexList.widthAnchor.constraint(equalToConstant: 25).isActive = true
        bibleTableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        bibleTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        setLayoutForDominantHand()
    }
    
    func setLayoutForDominantHand() {
        if dominantHand == "Left" {
            indexListLeadingAnchor = indexList.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
            indexListLeadingAnchor?.isActive = true
            indexListTrailingAnchor = indexList.trailingAnchor.constraint(equalTo: bibleTableView.leadingAnchor)
            indexListTrailingAnchor?.isActive = true
            bibleTableViewLeadingAnchor = bibleTableView.leadingAnchor.constraint(equalTo: indexList.trailingAnchor)
            bibleTableViewLeadingAnchor?.isActive = true
            bibleTableViewTrailingAnchor = bibleTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            bibleTableViewTrailingAnchor?.isActive = true
        } else {
            indexListTrailingAnchor = indexList.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            indexListTrailingAnchor?.isActive = true
            indexListLeadingAnchor = indexList.leadingAnchor.constraint(equalTo: bibleTableView.trailingAnchor)
            indexListLeadingAnchor?.isActive = true
            bibleTableViewTrailingAnchor = bibleTableView.trailingAnchor.constraint(equalTo: indexList.leadingAnchor)
            bibleTableViewTrailingAnchor?.isActive = true
            bibleTableViewLeadingAnchor = bibleTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
            bibleTableViewLeadingAnchor?.isActive = true
        }
    }
    
}
