//
//  SavedVerseView + DidSelectSavedVerse.swift
//  BibleApp
//
//  Created by Min Kim on 10/31/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

extension SavedVerseViewController: DidSelectSavedVersesDelegate {
    func didPress(forVerse savedVerse: SavedVerse, forIndexPath: IndexPath) {
        if isEditingSections {
            guard let cell = savedVerseTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? VersesWithoutSectionTableViewCell else {return}
            cell.setDeleteImage(for: forIndexPath)
            if versesToDelete.contains(savedVerse) {
                versesToDelete = versesToDelete.filter({$0 != savedVerse})
            } else {
                versesToDelete.append(savedVerse)
            }
        } else {
            savedVerseDelegate?.requestToOpenVerse(for: savedVerse)
        }
    }
    
}
