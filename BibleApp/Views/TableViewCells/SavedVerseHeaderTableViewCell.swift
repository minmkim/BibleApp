//
//  SavedVerseHeaderTableViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 10/20/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SavedVerseHeaderTableViewCell: UITableViewCell {
    
    var row: Int?
    weak var savedVerseHeaderDelegate: SavedVerseHeaderDelegate?
    
    let headerLabel: UILabel = {
        let hl = UILabel()
        let customFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        hl.font = UIFontMetrics.default.scaledFont(for: customFont)
        return hl
    }()
    
    let addButton: UIButton = {
        let ab = UIButton(type: .contactAdd)
        ab.tintColor = MainColor.redOrange
        return ab
    }()
    
    @objc func didPressAdd(_ sender: UIButton) {
        if let row = row {
            savedVerseHeaderDelegate?.didPressAddNote(at: row)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addButton.addTarget(self, action: #selector(didPressAdd), for: .touchUpInside)
        addSubviewsUsingAutoLayout(headerLabel, addButton)
        layoutViews()
    }
    
    func layoutViews() {
        headerLabel.leadingAnchor.constrain(to: leadingAnchor, with: 16)
        headerLabel.bottomAnchor.constrain(to: bottomAnchor, with: -8)
        headerLabel.widthAnchor.constrain(.lessThanOrEqual, to: widthAnchor, multiplyBy: 4/5)
        headerLabel.heightAnchor.constrain(to: 28)
        addButton.centerYAnchor.constrain(to: headerLabel.centerYAnchor)
        addButton.leadingAnchor.constrain(to: headerLabel.trailingAnchor, with: 4)
        addButton.widthAnchor.constrain(to: 28)
        addButton.heightAnchor.constrain(to: addButton.widthAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func addCancelButton() {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(didPressCancel), for: .touchUpInside)
        addSubviewsUsingAutoLayout(cancelButton)
        cancelButton.trailingAnchor.constrain(to: trailingAnchor)
        cancelButton.centerYAnchor.constrain(to: headerLabel.centerYAnchor)
        cancelButton.widthAnchor.constrain(to: 75)
        cancelButton.heightAnchor.constrain(to: 30)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func didPressCancel() {
        savedVerseHeaderDelegate?.didPressCancel()
    }
    
}


