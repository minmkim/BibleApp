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
       let tb = UIButton(type: .custom)
        tb.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
        tb.setImage(image, for: .normal)
        tb.tintColor = MainColor.redOrange
        tb.addTarget(self, action: #selector(didPressTrash), for: .touchUpInside)
        return tb
    }()
    
    let shareButton: UIButton = {
        let sb = UIButton(type: .custom)
        sb.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
        sb.setImage(image, for: .normal)
        sb.tintColor = MainColor.redOrange
        sb.addTarget(self, action: #selector(didPressShare), for: .touchUpInside)
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
        backgroundColor = .white
        layoutViews()
    }
    
    func layoutViews() {
        trashButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        trashButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        trashButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
        trashButton.widthAnchor.constraint(equalTo: trashButton.heightAnchor).isActive = true
        
        shareButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        shareButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
        shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}

protocol SavedVerseActionBarDelegate: class {
    func didPressTrash()
    func didPressShare()
}
