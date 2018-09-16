//
//  Array.swift
//  BibleApp
//
//  Created by Min Kim on 8/25/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func removeIndexPaths(at indexes: [IndexPath]) {
        let indexPathRows = indexes.map({$0.row})
        let newIndex = Set(indexPathRows).sorted(by: >)
        newIndex.forEach { (index) in
            remove(at: index)
        }
    }
}
