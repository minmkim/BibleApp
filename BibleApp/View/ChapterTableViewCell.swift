//
//  ChapterTableViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 9/27/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class ChapterTableViewCell: UITableViewCell {
    
    weak var didSelectChapterCVDelegate: DidSelectChapterCVDelegate?
    
    var numberOfChapters: Int? {
        didSet {
            chapterCollectionView.reloadData()
        }
    }
    
    let chapterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ChapterCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        return cv
    }()
    
    override func layoutSubviews() {
        addSubview(chapterCollectionView)
        chapterCollectionView.delegate = self
        chapterCollectionView.dataSource = self
        layoutViews()
    }
    
    func layoutViews() {
        chapterCollectionView.addAnchors(container: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ChapterTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfChapters ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chapterCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChapterCollectionViewCell
        cell.chapter = (indexPath.item + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chapter = indexPath.item + 1
        didSelectChapterCVDelegate?.didSelectChapter(for: chapter)
    }
    
    
}

protocol DidSelectChapterCVDelegate: class {
    func didSelectChapter(for chapter: Int)
}
