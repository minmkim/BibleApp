//
//  SavedVerseHeaderTableViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 10/20/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SavedVerseHeaderTableViewCell: UITableViewCell {
    
    let headerLabel: UILabel = {
       let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        hl.font = UIFontMetrics.default.scaledFont(for: customFont)
        return hl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(headerLabel)
        
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        headerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 4/5).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 28)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
