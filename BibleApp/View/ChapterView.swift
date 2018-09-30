//
//  ChapterView.swift
//  BibleApp
//
//  Created by Min Kim on 9/27/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class ChapterView: UIView {
    
    var numberOfChapters: Int?
    weak var chapterPressDelegate: ChapterPressDelegate?
    var currentChapter: Int? {
        didSet {
            updateProgressBar()
            if let currentChapter = currentChapter {
                chapterLabel.text = "CHAPTER \(currentChapter)"
            }
        }
    }
    
    let chapterLabel: UILabel = {
       let cl = UILabel()
        cl.translatesAutoresizingMaskIntoConstraints = false
        cl.font = UIFont.boldSystemFont(ofSize: 14)
        cl.isUserInteractionEnabled = true
        return cl
    }()
    
    let leftButton: chapterButton = {
       let lb = chapterButton()
        lb.setImage(UIImage(named: "leftArrow"), for: .normal)
        lb.tag = 0
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        return lb
    }()
    
    let rightButton: chapterButton = {
        let rb = chapterButton()
        rb.setImage(UIImage(named: "rightArrow"), for: .normal)
        rb.tag = 1
        rb.translatesAutoresizingMaskIntoConstraints = false
        rb.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        return rb
    }()
    
    lazy var labelChapterView: LabelChapterView = {
        let lc = LabelChapterView(frame: .zero)
        lc.didSelectChapterLabelViewDelegate = self
        lc.translatesAutoresizingMaskIntoConstraints = false
        return lc
    }()
    
    let progressBar: UIView = {
        let pb = UIView()
        pb.translatesAutoresizingMaskIntoConstraints = false
        pb.backgroundColor = MainColor.redOrange
        pb.alpha = 0.1
        pb.isUserInteractionEnabled = false
        return pb
    }()
    
    @objc func didPressLabel() {
        labelChapterView.numberOfChapters = numberOfChapters
        labelChapterView.chapterCollectionView.reloadData()
        labelChapterViewTopAnchor?.isActive = false
        labelChapterViewTopAnchor = labelChapterView.topAnchor.constraint(equalTo: topAnchor)
        labelChapterViewTopAnchor?.isActive = true
        if let currentChapter = currentChapter {
            labelChapterView.chapterCollectionView.scrollToItem(at: IndexPath(item: currentChapter - 1, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func didPressButton(_ sender: UIButton) {
        if sender.tag == 0 {
            chapterPressDelegate?.didPressPreviousChapter()
        } else {
            chapterPressDelegate?.didPressNextChapter()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(progressBar)
        addSubview(chapterLabel)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(labelChapterView)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didPressLabel))
        chapterLabel.addGestureRecognizer(recognizer)
        layoutViews()
    }
    
    var labelChapterViewTopAnchor: NSLayoutConstraint?
    var progressBarTrailingAnchor: NSLayoutConstraint?
    
    func layoutViews() {
        progressBar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        chapterLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        chapterLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        chapterLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
        chapterLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        
        leftButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        leftButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
        leftButton.widthAnchor.constraint(equalTo: leftButton.heightAnchor).isActive = true

        rightButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        rightButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
        rightButton.widthAnchor.constraint(equalTo: rightButton.heightAnchor).isActive = true

        labelChapterViewTopAnchor = labelChapterView.topAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        labelChapterViewTopAnchor?.isActive = true
        labelChapterView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        labelChapterView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        labelChapterView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        updateProgressBar()
    }
    
    func updateProgressBar() {
        let frameWidth = self.frame.width
        guard let currentChapter = currentChapter else {return}
        guard let numberOfChapters = numberOfChapters else {return}
        let multiplier = Double(currentChapter)/Double(numberOfChapters)
        let constant = frameWidth * CGFloat(multiplier)
        progressBarTrailingAnchor?.isActive = false
        progressBarTrailingAnchor = progressBar.trailingAnchor.constraint(equalTo: leadingAnchor, constant: constant)
        progressBarTrailingAnchor?.isActive = true
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    
}

extension ChapterView: DidSelectChapterLabelViewDelegate {
    func didSelectChapter(at chapter: Int) {
        labelChapterViewTopAnchor?.isActive = false
        labelChapterViewTopAnchor = labelChapterView.topAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        labelChapterViewTopAnchor?.isActive = true
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        chapterPressDelegate?.didPressChapterLabel(for: chapter)
    }
}

protocol ChapterPressDelegate: class {
    func didPressPreviousChapter()
    func didPressNextChapter()
    func didPressChapterLabel(for chapter: Int)
}

class chapterButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let padding = CGFloat(20)
        let extendedBounds = bounds.insetBy(dx: -padding, dy: -padding)
        return extendedBounds.contains(point)
    }
}
