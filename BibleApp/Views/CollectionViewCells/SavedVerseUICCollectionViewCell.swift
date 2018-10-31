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
    
    let deleteImage: UIImageView = {
        let di = UIImageView(image: UIImage(named: "delete"))
        di.translatesAutoresizingMaskIntoConstraints = false
        di.isHidden = true
        return di
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        addSubview(deleteImage)
        containerView.addSubview(noteLabel)
        
        layoutViews()
        containerView.bringSubview(toFront: noteLabel)
    }
    
    func layoutViews() {
        containerView.fillContainer(for: self)
        containerView.layer.cornerRadius = 16
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
        
        deleteImage.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        deleteImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        deleteImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        deleteImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
