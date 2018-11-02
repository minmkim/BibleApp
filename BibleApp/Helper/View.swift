//
//  View.swift
//  BibleApp
//
//  Created by Min Kim on 9/1/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviewsUsingAutoLayout(_ views: UIView ...) {
        views.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func fillContainer(for container: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func addAnchors(container: UIView, inset: UIEdgeInsets = .zero) {
        topAnchor.constrain(to: container.safeAreaLayoutGuide.topAnchor, with: inset.top)
        leadingAnchor.constrain(to: container.safeAreaLayoutGuide.leadingAnchor, with: inset.left)
        trailingAnchor.constrain(to: container.safeAreaLayoutGuide.trailingAnchor, with: -inset.right)
        bottomAnchor.constrain(to: container.safeAreaLayoutGuide.bottomAnchor, with: -inset.bottom)
    }
}
