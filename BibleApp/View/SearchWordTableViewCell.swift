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
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.font = .preferredFont(forTextStyle: .headline)
        bv.adjustsFontForContentSizeCategory = true
        return bv
    }()
    
    let bibleText: UILabel = {
       let bt = UILabel()
        bt.isUserInteractionEnabled = false
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.font = .preferredFont(forTextStyle: .subheadline)
        bt.adjustsFontForContentSizeCategory = true
        bt.numberOfLines = 0
        return bt
    }()
    
    override func layoutSubviews() {
        addSubview(bibleVerseLabel)
        addSubview(bibleText)
        
        bibleVerseLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        bibleVerseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        
        bibleText.topAnchor.constraint(equalTo: bibleVerseLabel.bottomAnchor, constant: 8).isActive = true
        bibleText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        bibleText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        bibleText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
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
