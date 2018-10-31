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
        return hl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        layoutViews()
    }
    
    func setupView() {
        isOpaque = false
        backgroundColor = .white
        alpha = 1
        addSubviewsUsingAutoLayout(headerLabel)
    }
    
    func layoutViews() {
        headerLabel.leadingAnchor.constrain(to: leadingAnchor, with: 16)
        headerLabel.centerYAnchor.constrain(to: centerYAnchor)
        headerLabel.heightAnchor.constrain(to: heightAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
