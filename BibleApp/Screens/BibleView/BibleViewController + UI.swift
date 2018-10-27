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
        indexList.topAnchor.constrain(to: containerView.topAnchor, with: 8)
        indexList.bottomAnchor.constrain(to: containerView.bottomAnchor, with: -8)
        indexList.widthAnchor.constrain(to: 25)
        bibleTableView.topAnchor.constrain(to: containerView.topAnchor)
        bibleTableView.bottomAnchor.constrain(to: containerView.bottomAnchor)
        setLayoutForDominantHand()
    }
    
    func setLayoutForDominantHand() {
        if dominantHand == "Left" {
            indexListLeadingAnchor = indexList.leadingAnchor.constrain(to: containerView.leadingAnchor)
            indexListLeadingAnchor?.isActive = true
            indexListTrailingAnchor = indexList.trailingAnchor.constrain(to: bibleTableView.leadingAnchor)
            indexListTrailingAnchor?.isActive = true
            bibleTableViewLeadingAnchor = bibleTableView.leadingAnchor.constrain(to: indexList.trailingAnchor)
            bibleTableViewLeadingAnchor?.isActive = true
            bibleTableViewTrailingAnchor = bibleTableView.trailingAnchor.constrain(to: containerView.trailingAnchor)
            bibleTableViewTrailingAnchor?.isActive = true
        } else {
            indexListTrailingAnchor = indexList.trailingAnchor.constrain(to: containerView.trailingAnchor)
            indexListTrailingAnchor?.isActive = true
            indexListLeadingAnchor = indexList.leadingAnchor.constrain(to: bibleTableView.trailingAnchor)
            indexListLeadingAnchor?.isActive = true
            bibleTableViewTrailingAnchor = bibleTableView.trailingAnchor.constrain(to: indexList.leadingAnchor)
            bibleTableViewTrailingAnchor?.isActive = true
            bibleTableViewLeadingAnchor = bibleTableView.leadingAnchor.constrain(to: containerView.leadingAnchor)
            bibleTableViewLeadingAnchor?.isActive = true
        }
    }
    
}
