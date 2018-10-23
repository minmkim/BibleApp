//
//  SavedVerseUICCollectionViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 10/20/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SavedVerseUICCollectionViewCell: UICollectionViewCell {
    
    let gradientLayer = CAGradientLayer()
    let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let noteLabel: UILabel = {
       let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.font = .preferredFont(forTextStyle: .headline)
        nl.adjustsFontForContentSizeCategory = true
        nl.textColor = .white
        return nl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        containerView.addSubview(noteLabel)
        
        layoutViews()
        containerView.bringSubview(toFront: noteLabel)
    }
    
    func layoutViews() {
        containerView.addAnchors(container: self, inset: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8))
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        containerView.clipsToBounds = true
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        noteLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        noteLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        noteLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        noteLabel.widthAnchor.constraint(equalToConstant: frame.width - 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
