//
//  SavedVerseActionBar.swift
//  BibleApp
//
//  Created by Min Kim on 10/1/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

final class SavedVerseActionBar: UIView {
    
    weak var savedVerseActionBarDelegate: SavedVerseActionBarDelegate?
    
    let trashButton: UIButton = {
       let tb = UIButton(type: .custom)
        let image = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
        tb.setImage(image, for: .normal)
        tb.tintColor = MainColor.redOrange
        tb.addTarget(self, action: #selector(didPressTrash), for: .touchUpInside)
        return tb
    }()
    
    let shareButton: UIButton = {
        let sb = UIButton(type: .custom)
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
        addSubviewsUsingAutoLayout(trashButton, shareButton)
        backgroundColor = .white
        layoutViews()
    }
    
    func layoutViews() {
        trashButton.centerYAnchor.constrain(to: centerYAnchor)
        trashButton.leadingAnchor.constrain(to: leadingAnchor, with: 12)
        trashButton.heightAnchor.constrain(to: heightAnchor, multiplyBy: 2/3)
        trashButton.widthAnchor.constrain(to: trashButton.heightAnchor)
        
        shareButton.centerYAnchor.constrain(to: centerYAnchor)
        shareButton.trailingAnchor.constrain(to: trailingAnchor, with: -12)
        shareButton.heightAnchor.constrain(to: heightAnchor, multiplyBy: 2/3)
        shareButton.widthAnchor.constrain(to: trashButton.heightAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


