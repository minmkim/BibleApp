//
//  VerseCollectionViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 8/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

final class VerseCollectionViewCell: UICollectionViewCell {
    
    var verse: SavedVerse? {
        didSet {
            if let verse = verse {
                bibleVerseLabel.text = verse.formattedVerse()
                bibleVerseText.text = verse.text
            }
        }
    }
    
    let containerView: UIView = {
       let cv = UIView()
        return cv
    }()
    
    let bibleVerseLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        return label
    }()
    
    let bibleVerseText: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isUserInteractionEnabled = false
        tv.font = .preferredFont(forTextStyle: .subheadline)
        tv.adjustsFontForContentSizeCategory = true
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.isScrollEnabled = false
        tv.textContainerInset = UIEdgeInsets.zero
        return tv
    }()
    
    let deleteImage: UIImageView = {
       let di = UIImageView(image: UIImage(named: "delete"))
        di.isHidden = true
        return di
    }()
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsUsingAutoLayout(containerView)
        containerView.addSubviewsUsingAutoLayout(bibleVerseLabel, bibleVerseText, deleteImage)
//        layer.cornerRadius = 16
//        layer.masksToBounds = true
        layoutViews()
    }
    
    func layoutViews() {
        containerView.fillContainer(for: self)
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        
        bibleVerseLabel.topAnchor.constrain(to: containerView.topAnchor, with: 8)
        bibleVerseLabel.leadingAnchor.constrain(to: containerView.leadingAnchor, with: 12)
        bibleVerseLabel.trailingAnchor.constrain(to: containerView.trailingAnchor, with: -12)
        bibleVerseLabel.heightAnchor.constrain(to: 19)
        
        bibleVerseText.leadingAnchor.constrain(to: bibleVerseLabel.leadingAnchor)
        bibleVerseText.trailingAnchor.constrain(to: bibleVerseLabel.trailingAnchor)
        bibleVerseText.topAnchor.constrain(to: bibleVerseLabel.bottomAnchor, with: 4)
        bibleVerseText.bottomAnchor.constrain(to: containerView.bottomAnchor)
        
        deleteImage.topAnchor.constrain(to: containerView.topAnchor)
        deleteImage.trailingAnchor.constrain(to: containerView.trailingAnchor)
        deleteImage.heightAnchor.constrain(to: 25)
        deleteImage.widthAnchor.constrain(to: deleteImage.heightAnchor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        containerView.clipsToBounds = true
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
