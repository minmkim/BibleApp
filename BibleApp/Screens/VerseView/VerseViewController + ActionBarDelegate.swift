//
//  VerseViewController + ActionBarDelegate.swift
//  BibleApp
//
//  Created by Min Kim on 10/21/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension VerseViewController: SavedVerseActionBarDelegate {
    func didPressTrash() {
        if !indexPathToDelete.isEmpty {
            indexPathToDelete.forEach { (indexPath) in
                let cell = self.verseCollectionView.cellForItem(at: indexPath) as! VerseCollectionViewCell
                cell.deleteImage.isHidden = true
                dataManager?.deleteVerse(for: savedVerses[indexPath.row])
            }
            savedVerses.removeIndexPaths(at: indexPathToDelete)
            verseCollectionView.performBatchUpdates({
                verseCollectionView.deleteItems(at: indexPathToDelete)
            }) { (true) in
                self.indexPathToDelete.removeAll()
            }
            setupEditView()
        }
    }
    
    func didPressShare() {
        var text = ""
        indexPathToDelete.forEach { (indexPath) in
            let verse = savedVerses[indexPath.item]
            text += "\n\(verse.formattedVerseAndText())\n"
        }
        if text != "" {
            text.removeFirst()
            text.removeLast()
            let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            setupEditView()
        }
    }
    
}
