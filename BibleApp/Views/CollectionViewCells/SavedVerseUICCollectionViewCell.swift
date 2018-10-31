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
        return cv
    }()
    
    let noteLabel: UILabel = {
        let nl = UILabel()
        nl.font = .preferredFont(forTextStyle: .headline)
        nl.adjustsFontForContentSizeCategory = true
        nl.textColor = .white
        return nl
    }()
    
    let deleteImage: UIImageView = {
        let di = UIImageView(image: UIImage(named: "delete"))
        di.isHidden = true
        return di
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsUsingAutoLayout(containerView, deleteImage)
        containerView.addSubviewsUsingAutoLayout(noteLabel)
        
        layoutViews()
        containerView.bringSubview(toFront: noteLabel)
    }
    
    func layoutViews() {
        containerView.fillContainer(for: self)
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        containerView.clipsToBounds = true
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        noteLabel.centerXAnchor.constrain(to: centerXAnchor)
        noteLabel.centerYAnchor.constrain(to: centerYAnchor)
        noteLabel.heightAnchor.constrain(to: 26)
        noteLabel.widthAnchor.constrain(to: frame.width - 16)
        
        deleteImage.topAnchor.constrain(to: topAnchor, with: 2)
        deleteImage.trailingAnchor.constrain(to: trailingAnchor, with: -2)
        deleteImage.widthAnchor.constrain(to: 25)
        deleteImage.heightAnchor.constrain(to: 25)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
