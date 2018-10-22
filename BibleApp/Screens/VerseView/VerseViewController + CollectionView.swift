//
//  VerseViewController + CollectionView.swift
//  BibleApp
//
//  Created by Min Kim on 10/21/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension VerseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedVerses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = verseCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VerseCollectionViewCell
        cell.verse = savedVerses[indexPath.item]
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressCell))
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80 //Arbitrary number
        let verse = savedVerses[indexPath.item]
        height = estimatedFrameForText(text: verse.text).height + 44
        return CGSize(width: verseCollectionView.frame.width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: (view.frame.width - 56), height: 500)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.preferredFont(forTextStyle: .subheadline)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = verseCollectionView.cellForItem(at: indexPath) as! VerseCollectionViewCell
        if !isEditingVerses {
            guard let verse = cell.verse else {return}
            savedVerseDelegate?.requestToOpenVerse(for: verse)
        } else {
            if cell.deleteImage.isHidden {
                cell.deleteImage.isHidden = false
                indexPathToDelete.append(indexPath)
            } else {
                cell.deleteImage.isHidden = true
                indexPathToDelete = indexPathToDelete.filter( {$0 != indexPath})
            }
        }
    }
    
}
