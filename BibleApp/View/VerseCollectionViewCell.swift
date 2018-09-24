//
//  VerseCollectionViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 8/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

final class VerseCollectionViewCell: UICollectionViewCell {
    
    var verse: BibleVerse? {
        didSet {
            if let verse = verse {
                let verseLabel = "\(verse.book) \(verse.chapter):\(verse.verse)"
                bibleVerseLabel.text = verseLabel
                bibleVerseText.text = verse.text
            }
        }
    }
    
    let containerView: UIView = {
       let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let bibleVerseLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        return label
    }()
    
    let bibleVerseText: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .preferredFont(forTextStyle: .subheadline)
        tv.adjustsFontForContentSizeCategory = true
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.isScrollEnabled = false
        return tv
    }()
    
    let deleteImage: UIImageView = {
       let di = UIImageView(image: UIImage(named: "delete"))
        di.translatesAutoresizingMaskIntoConstraints = false
        di.isHidden = true
        return di
    }()
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        addSubview(bibleVerseLabel)
        addSubview(bibleVerseText)
        addSubview(deleteImage)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        layoutViews()
//        backgroundColor = .yellow
    }
    
    func layoutViews() {
        containerView.addAnchors(container: self, inset: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8))
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        
        bibleVerseLabel.addSpecificAnchors(topContainer: containerView, leadingContainer: containerView, trailingContainer: containerView, bottomContainer: nil, heightConstant: 16, widthConstant: nil, heightContainer: nil, widthContainer: nil, inset: UIEdgeInsets(top: 8, left: 12, bottom: 0, right: -12))
        bibleVerseText.addSpecificAnchors(topContainer: nil, leadingContainer: bibleVerseLabel, trailingContainer: bibleVerseLabel, bottomContainer: containerView, heightConstant: nil, widthConstant: nil, heightContainer: nil, widthContainer: nil)
        bibleVerseText.topAnchor.constraint(equalTo: bibleVerseLabel.bottomAnchor).isActive = true
        
        deleteImage.addSpecificAnchors(topContainer: containerView, leadingContainer: nil, trailingContainer: containerView, bottomContainer: nil, heightConstant: 25, widthConstant: nil, heightContainer: nil, widthContainer: nil)
        deleteImage.widthAnchor.constraint(equalTo: deleteImage.heightAnchor).isActive = true
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
