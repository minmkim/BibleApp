//
//  VerseCollectionViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 8/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class VerseCollectionViewCell: UICollectionViewCell {
    
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
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let bibleVerseText: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .systemFont(ofSize: 14)
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
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        
        bibleVerseLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        bibleVerseLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12).isActive = true
        bibleVerseLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12).isActive = true
        bibleVerseLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        bibleVerseText.topAnchor.constraint(equalTo: bibleVerseLabel.bottomAnchor).isActive = true
        bibleVerseText.leadingAnchor.constraint(equalTo: bibleVerseLabel.leadingAnchor).isActive = true
        bibleVerseText.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bibleVerseText.trailingAnchor.constraint(equalTo: bibleVerseLabel.trailingAnchor).isActive = true
        
        deleteImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        deleteImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4).isActive = true
        deleteImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        deleteImage.widthAnchor.constraint(equalTo: deleteImage.heightAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        print("reset")
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
