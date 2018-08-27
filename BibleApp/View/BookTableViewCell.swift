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
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        backgroundView.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 0.1)
        selectedBackgroundView = backgroundView
    }
    
    func layoutViews() {
        verseText.topAnchor.constraint(equalTo: topAnchor).isActive = true
        verseText.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        verseText.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        verseText.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        
        numberLabel.topAnchor.constraint(equalTo: verseText.topAnchor).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: 8).isActive = true

    }

}
