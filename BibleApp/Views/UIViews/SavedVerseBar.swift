//
//  SavedVerseActionBar.swift
//  BibleApp
//
//  Created by Min Kim on 10/1/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class SavedVerseBar: UIView {
    
    weak var saveVerseBarDelegate: SaveVerseBarDelegate?
    
    let trashButton: UIButton = {
        let tb = UIButton(type: .custom)
        tb.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
        tb.setImage(image, for: .normal)
        tb.tintColor = MainColor.redOrange
        tb.addTarget(self, action: #selector(didPressTrash), for: .touchUpInside)
        return tb
    }()
    
    let addButton: UIButton = {
        let ab = UIButton(type: .custom)
        ab.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        ab.setImage(image, for: .normal)
        ab.tintColor = MainColor.redOrange
        ab.addTarget(self, action: #selector(didPressShare), for: .touchUpInside)
        return ab
    }()
    
    @objc func didPressShare(_ sender: UIButton) {
        saveVerseBarDelegate?.didPressAdd()
    }
    
    @objc func didPressTrash(_ sender: UIButton) {
        saveVerseBarDelegate?.didPressTrash()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(trashButton)
        addSubview(addButton)
        backgroundColor = .white
        layoutViews()
    }
    
    func layoutViews() {
        trashButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        trashButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        trashButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
        trashButton.widthAnchor.constraint(equalTo: trashButton.heightAnchor).isActive = true
        
        addButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        addButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
        addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}

protocol SaveVerseBarDelegate: class {
    func didPressTrash()
    func didPressAdd()
}
