//
//  ChapterCollectionViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 9/27/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class ChapterCollectionViewCell: UICollectionViewCell {
    
    var chapter: Int? {
        didSet {
            chapterLabel.text = "\(chapter!)"
        }
    }
    
    let chapterLabel: UILabel = {
       let cl = UILabel()
        cl.textColor = MainColor.redOrange
        cl.font = .boldSystemFont(ofSize: 14)
        return cl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsUsingAutoLayout(chapterLabel)
        layoutViews()
    }
    
    func layoutViews() {
        chapterLabel.widthAnchor.constrain(.greaterThanOrEqual, to: 24)
        chapterLabel.heightAnchor.constrain(to: 18)
        chapterLabel.centerXAnchor.constrain(to: centerXAnchor)
        chapterLabel.centerYAnchor.constrain(to: centerYAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
