//
//  SearchHeader.swift
//  BibleApp
//
//  Created by Min Kim on 9/29/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class SearchHeader: UIView {
    
    let headerLabel: UILabel = {
        let hl = UILabel()
        hl.font = .preferredFont(forTextStyle: .headline)
        hl.adjustsFontForContentSizeCategory = true
        hl.textColor = .black
        hl.translatesAutoresizingMaskIntoConstraints = false
        return hl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        backgroundColor = .white
        alpha = 1
        addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
