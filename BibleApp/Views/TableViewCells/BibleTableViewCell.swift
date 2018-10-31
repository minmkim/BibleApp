//
//  BibleTableViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 10/7/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class BibleTableViewCell: UITableViewCell {
    
    var bibleBook: String? {
        didSet {
            if let book = bibleBook {
                bookLabel.text = book
            }
        }
    }
    
    let bookLabel: UILabel = {
       let bl = UILabel()
        bl.font = .preferredFont(forTextStyle: .headline)
        bl.adjustsFontForContentSizeCategory = true
        return bl
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 0.1)
        selectedBackgroundView = backgroundView
        addSubviewsUsingAutoLayout(bookLabel)
        layoutViews()
    }
    
    func layoutViews() {
        bookLabel.centerYAnchor.constrain(to: centerYAnchor)
        bookLabel.leadingAnchor.constrain(to: leadingAnchor, with: 12)
        bookLabel.heightAnchor.constrain(to: 20)
        bookLabel.widthAnchor.constrain(.lessThanOrEqual, to: widthAnchor, multiplyBy: 3/4)
    }

}
