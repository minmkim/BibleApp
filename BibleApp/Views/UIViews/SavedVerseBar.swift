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
        let image = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
        tb.setImage(image, for: .normal)
        tb.tintColor = MainColor.redOrange
        tb.addTarget(self, action: #selector(didPressTrash), for: .touchUpInside)
        return tb
    }()
    
    let addButton: UIButton = {
        let ab = UIButton(type: .custom)
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
        addSubviewsUsingAutoLayout(trashButton, addButton)
        backgroundColor = .white
        layoutViews()
    }
    
    func layoutViews() {
        trashButton.centerYAnchor.constrain(to: centerYAnchor)
        trashButton.leadingAnchor.constrain(to: leadingAnchor, with: 12)
        trashButton.heightAnchor.constrain(to: heightAnchor, multiplyBy: 2/3)
        trashButton.widthAnchor.constrain(to: trashButton.heightAnchor)
        
        addButton.centerYAnchor.constrain(to: centerYAnchor)
        addButton.trailingAnchor.constrain(to: trailingAnchor, with: -12)
        addButton.heightAnchor.constrain(to: heightAnchor, multiplyBy: 2/3)
        addButton.widthAnchor.constrain(to: addButton.heightAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}

protocol SaveVerseBarDelegate: class {
    func didPressTrash()
    func didPressAdd()
}
