//
//  ChapterButton.swift
//  BibleApp
//
//  Created by Min Kim on 11/1/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class chapterButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let padding = CGFloat(20)
        let extendedBounds = bounds.insetBy(dx: -padding, dy: -padding)
        return extendedBounds.contains(point)
    }
}
