//
//  SavedVerseTableViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 10/20/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SavedVerseTableViewCell: UITableViewCell {
    
    var row: Int?
    var notes = [String]() {
        didSet {
            savedVerseCollectionView.reloadData()
        }
    }
    
    let savedVerseCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let sv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        sv.register(SavedVerseUICCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        sv.register(VerseCollectionViewCell.self, forCellWithReuseIdentifier: "verse")
        sv.backgroundColor = .white
        sv.showsHorizontalScrollIndicator = false
        sv.contentInset = UIEdgeInsets(top: 4, left: 8, bottom: 0, right: 8)
        return sv
    }()
    
    weak var didPressNoteDelegate: DidPressNoteDelegate?
    weak var didDragVerseDelegate: DidDragVerseDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupDelegates()
        layoutViews()
    }
    
    func setupViews() {
        addSubviewsUsingAutoLayout(savedVerseCollectionView)
    }
    
    func setupDelegates() {
        savedVerseCollectionView.delegate = self
        savedVerseCollectionView.dataSource = self
        savedVerseCollectionView.dropDelegate = self
    }
    
    func layoutViews() {
        savedVerseCollectionView.fillContainer(for: self)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SavedVerseTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = savedVerseCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SavedVerseUICCollectionViewCell
        cell.noteLabel.text = notes[indexPath.item]
        cell.deleteImage.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 40, height: 70)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let row = row {
            didPressNoteDelegate?.didPressNote(at: indexPath, row: row, note: notes[indexPath.item])
        }
        
    }
}

extension SavedVerseTableViewCell: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        for item in coordinator.items {
            item.dragItem.itemProvider.loadObject(ofClass: SavedVerse.self, completionHandler: { [weak self] (verse, error) in
                if let verse = verse as? SavedVerse {
                    guard let indexPath = coordinator.destinationIndexPath else {return}
                    let note = self?.notes[indexPath.item] ?? ""
                    self?.didDragVerseDelegate?.didDragVerse(for: verse, note: note, row: self?.row ?? 0)
                }
            })
        }
    }
}
