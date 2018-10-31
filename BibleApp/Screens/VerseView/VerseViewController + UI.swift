//
//  VerseViewController + UI.swift
//  BibleApp
//
//  Created by Min Kim on 10/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

extension VerseViewController {
    
    func layoutViews() {
        containerView.fillContainer(for: self.view)
        verseCollectionView.fillContainer(for: containerView)
        actionBar.widthAnchor.constrain(to: view.widthAnchor)
        actionBar.heightAnchor.constrain(to: 40)
        actionBar.leadingAnchor.constrain(to: view.leadingAnchor).isActive = true
        actionBarTopAnchor = actionBar.topAnchor.constrain(to: view.bottomAnchor, with: -40)
        actionBarTopAnchor?.isActive = true
    }
}
