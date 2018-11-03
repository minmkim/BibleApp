//
//  LabelChapterView.swift
//  BibleApp
//
//  Created by Min Kim on 9/28/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

final class LabelChapterView: UIView {
    
    weak var didSelectChapterLabelViewDelegate: DidSelectChapterLabelViewDelegate?
    var currentChapter: Int?
    var numberOfChapters: Int? {
        didSet {
            if let numberOfChapters = numberOfChapters {
                arrayOfChapters = Array(1...numberOfChapters)
            }
        }
    }
    var arrayOfChapters = [Int]()
    
    lazy var chapterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = cellSpacing
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(ChapterCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsUsingAutoLayout(chapterCollectionView)
        chapterCollectionView.delegate = self
        chapterCollectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        layoutViews()
    }
    
    func layoutViews() {
        chapterCollectionView.addAnchors(container: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellWidth: CGFloat = 30
    let cellSpacing: CGFloat = 2
    

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chapter = indexPath.item + 1
        didSelectChapterLabelViewDelegate?.didSelectChapter(at: chapter)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = cellWidth * CGFloat((numberOfChapters ?? 0))
        let totalSpacingWidth = cellSpacing * CGFloat((numberOfChapters ?? 0) - 1)
        if (totalCellWidth + totalSpacingWidth) < self.frame.width {
            let leftInset = (self.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        } else {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: 30)
    }
}
