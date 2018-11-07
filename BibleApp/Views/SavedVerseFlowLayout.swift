//
//  SavedVerseFlowLayout.swift
//  BibleApp
//
//  Created by Min Kim on 11/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class SavedVerseFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
