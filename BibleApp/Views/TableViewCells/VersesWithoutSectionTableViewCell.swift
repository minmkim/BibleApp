//
//  VersesWithoutSectionTableViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 10/21/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit
import MobileCoreServices

class VersesWithoutSectionTableViewCell: SavedVerseTableViewCell {
    
    var savedVerses = [SavedVerse]()
    var indexPathsToDelete = [IndexPath]()
    var draggedIndexPath: IndexPath?
    weak var didSelectSavedVersesDelegate: DidSelectSavedVersesDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        savedVerseCollectionView.dragInteractionEnabled = true
        savedVerseCollectionView.dragDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeVerses() {
        indexPathsToDelete.sort(by: {$0.row > $1.row})
        for index in self.indexPathsToDelete {
            self.savedVerses.remove(at: index.item)
        }
        DispatchQueue.main.async {
            self.savedVerseCollectionView.deleteItems(at: self.indexPathsToDelete)
            self.indexPathsToDelete.removeAll()
        }
        savedVerseCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setDeleteImage(forIndexPath: IndexPath) -> Bool {
        return indexPathsToDelete.contains(forIndexPath) ? false : true
    }
    
}

extension VersesWithoutSectionTableViewCell {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedVerses.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = savedVerseCollectionView.dequeueReusableCell(withReuseIdentifier: "verse", for: indexPath) as! VerseCollectionViewCell
        cell.verse = savedVerses[indexPath.item]
        cell.deleteImage.isHidden = setDeleteImage(forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80 //Arbitrary number
        let verse = savedVerses[indexPath.item]
        height = estimatedFrameForText(text: verse.text).height + 38
        if height > 150 {
            height = 120
        }
        return CGSize(width: self.frame.width - 40, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: (self.frame.width - 96), height: 500)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.preferredFont(forTextStyle: .subheadline)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = savedVerseCollectionView.cellForItem(at: indexPath) as? VerseCollectionViewCell else {return}
        guard let verse = cell.verse else {return}
        if cell.deleteImage.isHidden {
            cell.deleteImage.isHidden = false
            indexPathsToDelete.append(indexPath)
        } else {
            cell.deleteImage.isHidden = true
            indexPathsToDelete = indexPathsToDelete.filter({$0 != indexPath})
        }
        didSelectSavedVersesDelegate?.didPress(forVerse: verse)
    }
    
}

extension VersesWithoutSectionTableViewCell: UICollectionViewDragDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let cell = savedVerseCollectionView.cellForItem(at: indexPath) as! VerseCollectionViewCell
        guard let verse = cell.verse else {return []}
        draggedIndexPath = indexPath
        let itemProvider = NSItemProvider(object: verse)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    
    
    
}

protocol DidSelectSavedVersesDelegate: class {
    func didPress(forVerse savedVerse: SavedVerse)
}
