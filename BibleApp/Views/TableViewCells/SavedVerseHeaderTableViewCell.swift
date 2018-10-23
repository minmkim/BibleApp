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
    var didPressAddNoteDelegate: DidPressAddNoteDelegate?
    
    let headerLabel: UILabel = {
       let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        hl.font = UIFontMetrics.default.scaledFont(for: customFont)
        return hl
    }()
    
    let addButton: UIButton = {
        let ab = UIButton(type: .contactAdd)
//        ab.setImage(UIImage(named: "add"), for: .normal)
        ab.tintColor = MainColor.redOrange
        ab.translatesAutoresizingMaskIntoConstraints = false
        return ab
    }()
    
    @objc func didPressAdd(_ sender: UIButton) {
        if let row = row {
            didPressAddNoteDelegate?.didPressAddNote(at: row)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(headerLabel)
        addSubview(addButton)
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        headerLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 4/5).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 28)
        addButton.addTarget(self, action: #selector(didPressAdd), for: .touchUpInside)
        addButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
        addButton.leadingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 4).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
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
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(didPressCancel), for: .touchUpInside)
        addSubview(cancelButton)
        cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didPressCancel() {
//        dismiss(animated: true, completion: nil)
        print("did press cancel")
    }

}

protocol DidPressAddNoteDelegate: class {
    func didPressAddNote(at row: Int)
}
