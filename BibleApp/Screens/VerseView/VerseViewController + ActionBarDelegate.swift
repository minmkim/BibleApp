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
                guard let cell = verseCollectionView.cellForItem(at: indexPath) as? VerseCollectionViewCell else {return}
                guard let verse = cell.verse else {return}
                cell.deleteImage.isHidden = true
                savedVersesModel?.deleteVerse(verse)
            }
            savedVerses.removeIndexPaths(at: indexPathToDelete)
            verseCollectionView.performBatchUpdates({
                verseCollectionView.deleteItems(at: indexPathToDelete)
            }) { [unowned self] (true) in
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
