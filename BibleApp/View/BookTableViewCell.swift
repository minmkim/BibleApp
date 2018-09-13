//
//  BookTableViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 8/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    var verse: String? {
        didSet {
            verseText.text = verse
            layoutIfNeeded()
        }
    }
    
    let verseText: UITextView = {
        let tv = UITextView()
        tv.font = .preferredFont(forTextStyle: .callout)
        tv.adjustsFontForContentSizeCategory = true
        tv.textColor = .black
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 8)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        addSubview(verseText)
        addSubview(numberLabel)
        layoutViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        backgroundView.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 0.1)
        selectedBackgroundView = backgroundView
    }
    
    func layoutViews() {
        verseText.addAnchors(container: self, inset: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: -12))
        numberLabel.addSpecificAnchors(topContainer: verseText, leadingContainer: self, trailingContainer: nil, bottomContainer: nil, heightConstant: 8, widthConstant: nil, heightContainer: nil, widthContainer: nil, inset: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0))
    }

}
