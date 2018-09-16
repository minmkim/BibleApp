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
    
    func fillContainer(for container: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func addAnchors(container: UIView, inset: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: inset.top).isActive = true
        leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor, constant: inset.left).isActive = true
        trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor, constant: inset.right).isActive = true
        bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: inset.bottom).isActive = true
    }
    
    func addSpecificAnchors(topContainer: UIView?, leadingContainer: UIView?, trailingContainer: UIView?, bottomContainer: UIView?, heightConstant: CGFloat?, widthConstant: CGFloat?, heightContainer: UIView?, heightMultiplier: CGFloat = 1.0, widthContainer: UIView?, widthMultiplier: CGFloat = 1.0, inset: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let topContainer = topContainer {
            topAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.topAnchor, constant: inset.top).isActive = true
        }
        if let leadingContainer = leadingContainer {
            leadingAnchor.constraint(equalTo: leadingContainer.safeAreaLayoutGuide.leadingAnchor, constant: inset.left).isActive = true
        }
        
        if let trailingContainer = trailingContainer {
            trailingAnchor.constraint(equalTo: trailingContainer.safeAreaLayoutGuide.trailingAnchor, constant: inset.right).isActive = true
        }
        
        if let bottomContainer = bottomContainer {
            bottomAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.bottomAnchor, constant: inset.bottom).isActive = true
        }
        if let heightConstant = heightConstant {
            heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
        
        if let widthConstant = widthConstant {
            widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        
        if let heightContainer = heightContainer {
            heightAnchor.constraint(equalTo: heightContainer.heightAnchor, multiplier: heightMultiplier)
        }
        
        if let widthContainer = widthContainer {
            widthAnchor.constraint(equalTo: widthContainer.widthAnchor, multiplier: widthMultiplier)
        }
        
    }
}
