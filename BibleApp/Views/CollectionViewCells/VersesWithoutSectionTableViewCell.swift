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
    
    var savedVerses = [SavedVerse]() {
        didSet {
            print(savedVerses.count)
        }
    }
    
    var draggedIndexPath: IndexPath?
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
    
}

extension VersesWithoutSectionTableViewCell {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedVerses.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("load collection cell")
        let cell = savedVerseCollectionView.dequeueReusableCell(withReuseIdentifier: "verse", for: indexPath) as! VerseCollectionViewCell
        cell.verse = savedVerses[indexPath.item]
        return cell
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
