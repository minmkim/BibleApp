//
//  BookTableViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 8/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

final class BookTableViewCell: UITableViewCell {
    
    var dominantHand = DominantHand.left.rawValue
    
    var bibleVerse: String? {
        didSet {
            verseText.text = bibleVerse
            layoutIfNeeded()
        }
    }
    
    let verseText: UILabel = {
        let tv = UILabel()
        tv.font = .preferredFont(forTextStyle: .callout)
        tv.adjustsFontForContentSizeCategory = true
        tv.textColor = .black
        tv.numberOfLines = 0
        return tv
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 8)
        label.textColor = .black
        return label
    }()
    
    override func layoutSubviews() {
        addSubviewsUsingAutoLayout(verseText, numberLabel)
        layoutViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        backgroundView.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 0.1)
        selectedBackgroundView = backgroundView
    }
    
    func layoutViews() {
        if dominantHand == DominantHand.left.rawValue {
            verseText.addAnchors(container: self, inset: UIEdgeInsets(top: 8, left: 36, bottom: 8, right: 16))
            
            numberLabel.topAnchor.constrain(to: topAnchor)
            numberLabel.leadingAnchor.constrain(to: leadingAnchor, with: 22)
            numberLabel.heightAnchor.constrain(to: 8)
        } else {
            verseText.addAnchors(container: self, inset: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 22))
            numberLabel.topAnchor.constrain(to: topAnchor)
            numberLabel.leadingAnchor.constrain(to: leadingAnchor, with: 6)
            numberLabel.heightAnchor.constrain(to: 8)
        }
    }

}
