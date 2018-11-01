//
//  SavedVerseView + DidSelectSavedVerse.swift
//  BibleApp
//
//  Created by Min Kim on 10/31/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

extension SavedVerseViewController: DidSelectSavedVersesDelegate {
    func didPress(forVerse savedVerse: SavedVerse) {
        if versesToDelete.contains(savedVerse) {
            versesToDelete = versesToDelete.filter({$0 != savedVerse})
        } else {
            versesToDelete.append(savedVerse)
        }
    }
    
}
