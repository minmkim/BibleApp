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
        cl.translatesAutoresizingMaskIntoConstraints = false
        cl.textColor = MainColor.redOrange
        cl.font = .boldSystemFont(ofSize: 14)
        return cl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(chapterLabel)
        layoutViews()
    }
    
    func layoutViews() {
        chapterLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 24)
        chapterLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        chapterLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        chapterLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
