//
//  LabelChapterView.swift
//  BibleApp
//
//  Created by Min Kim on 9/28/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class LabelChapterView: UIView {
    
    var currentChapter: Int?
    var numberOfChapters: Int? {
        didSet {
            if let numberOfChapters = numberOfChapters {
                arrayOfChapters = Array(1...numberOfChapters)
            }
        }
    }
    var arrayOfChapters = [Int]()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(chapterCollectionView)
        chapterCollectionView.delegate = self
        chapterCollectionView.dataSource = self
        layoutViews()
    }
    
    func layoutViews() {
        chapterCollectionView.addAnchors(container: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension LabelChapterView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfChapters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chapterCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChapterCollectionViewCell
        cell.chapter = (indexPath.item + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
}
