//
//  SavedVerseView + DidPressNote.swift
//  BibleApp
//
//  Created by Min Kim on 10/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension SavedVerseViewController: DidPressNoteDelegate {
    func didPressNote(at indexPath: IndexPath, row: Int, note: String) {
        let index = getSectionNumberOfCollectionViewRow(from: row)
        switch controllerState {
        case .note:
            if isEditingSections {
                let cell = savedVerseTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SavedVerseTableViewCell
                let insideCell = cell?.savedVerseCollectionView.cellForItem(at: indexPath) as? SavedVerseUICCollectionViewCell
                if insideCell?.deleteImage.isHidden ?? true {
                    insideCell?.deleteImage.isHidden = false
                } else {
                    insideCell?.deleteImage.isHidden = true
                }
                itemsToDelete.append(ItemToDelete(section: savedVersesModel.getSection(for: index), note: insideCell?.noteLabel.text))
            } else {
                openNoteDelegate?.didPressNote(forNote: note, index: index)
            }
            
        case .search:
            didSelectNoteDelegate?.selectedNoteSection(note: note, section: savedVersesModel?.getSection(for: index) ?? "")
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}
