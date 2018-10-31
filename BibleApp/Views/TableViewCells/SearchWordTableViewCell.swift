//
//  SearchWordTableViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 9/29/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SearchWordTableViewCell: UITableViewCell {
    
    var bibleVerse: BibleVerse? {
        didSet {
            if let bibleVerse = bibleVerse {
                bibleVerseLabel.text = bibleVerse.formattedVerse()
                bibleText.text = bibleVerse.text
            }
        }
    }
    
    let bibleVerseLabel: UILabel = {
        let bv = UILabel()
        bv.font = .preferredFont(forTextStyle: .headline)
        bv.adjustsFontForContentSizeCategory = true
        return bv
    }()
    
    let bibleText: UILabel = {
       let bt = UILabel()
        bt.isUserInteractionEnabled = false
        bt.font = .preferredFont(forTextStyle: .subheadline)
        bt.adjustsFontForContentSizeCategory = true
        bt.numberOfLines = 0
        return bt
    }()
    
    override func layoutSubviews() {
        addSubviewsUsingAutoLayout(bibleVerseLabel, bibleText)
        layoutViews()
    }
    
    func layoutViews() {
        bibleVerseLabel.topAnchor.constrain(to: topAnchor, with: 8)
        bibleVerseLabel.leadingAnchor.constrain(to: leadingAnchor, with: 8)
        
        bibleText.topAnchor.constrain(to: bibleVerseLabel.bottomAnchor, with: 8)
        bibleText.leadingAnchor.constrain(to: leadingAnchor, with: 8)
        bibleText.trailingAnchor.constrain(to: trailingAnchor, with: -8)
        bibleText.bottomAnchor.constrain(to: bottomAnchor, with: -8)
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
