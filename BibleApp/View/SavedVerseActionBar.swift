//
//  SavedVerseActionBar.swift
//  BibleApp
//
//  Created by Min Kim on 10/1/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class SavedVerseActionBar: UIView {
    
    weak var savedVerseActionBarDelegate: SavedVerseActionBarDelegate?
    
    let trashButton: UIButton = {
       let tb = UIButton()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.setImage(UIImage(named: "trash"), for: .normal)
        tb.addTarget(self, action: #selector(didPressTrash), for: .touchUpInside)
        tb.tintColor = MainColor.redOrange
        return tb
    }()
    
    let shareButton: UIButton = {
        let sb = UIButton()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.setImage(UIImage(named: "share"), for: .normal)
        sb.addTarget(self, action: #selector(didPressShare), for: .touchUpInside)
        sb.tintColor = MainColor.redOrange
        return sb
    }()
    
    @objc func didPressShare(_ sender: UIButton) {
        savedVerseActionBarDelegate?.didPressShare()
    }
    
    @objc func didPressTrash(_ sender: UIButton) {
        savedVerseActionBarDelegate?.didPressTrash()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(trashButton)
        addSubview(shareButton)
        layoutViews()
    }
    
    func layoutViews() {
        trashButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        trashButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        trashButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
        
        shareButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        shareButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}

protocol SavedVerseActionBarDelegate: class {
    func didPressTrash()
    func didPressShare()
}
