//
//  SavedVerseView + DidDragVerse.swift
//  BibleApp
//
//  Created by Min Kim on 10/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension SavedVerseViewController: DidDragVerseDelegate {
    func didDragVerse(for verse: SavedVerse, note: String, row: Int) {
        let index = getSectionNumberOfCollectionViewRow(from: row)
        guard let section = savedVersesModel?.getSection(for: index) else {return}
        
        DispatchQueue.main.async { [unowned self] in
            let cell = self.savedVerseTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! VersesWithoutSectionTableViewCell
            if let indexPath = cell.draggedIndexPath {
                cell.savedVerses.remove(at: indexPath.item)
                cell.savedVerseCollectionView.deleteItems(at: [indexPath])
            }
            
            if cell.savedVerses.isEmpty {
                self.heightOfRows[IndexPath(row: 1, section: 0)] = 0
                self.savedVerseTableView.beginUpdates()
                self.savedVerseTableView.endUpdates()
            }
        }
        
        savedVersesModel?.updateVerseToNote(verse: verse, note: note, section: section)
    }
    
    
}
