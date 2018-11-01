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
        cl.font = UIFont.boldSystemFont(ofSize: 14)
        cl.isUserInteractionEnabled = true
        return cl
    }()
    
    let leftButton: chapterButton = {
       let lb = chapterButton()
        lb.setImage(UIImage(named: "leftArrow"), for: .normal)
        lb.tag = 0
        lb.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        return lb
    }()
    
    let rightButton: chapterButton = {
        let rb = chapterButton()
        rb.setImage(UIImage(named: "rightArrow"), for: .normal)
        rb.tag = 1
        rb.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        return rb
    }()
    
    lazy var labelChapterView: LabelChapterView = {
        let lc = LabelChapterView(frame: .zero)
        lc.didSelectChapterLabelViewDelegate = self
        return lc
    }()
    
    let progressBar: UIView = {
        let pb = UIView()
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
        addSubviewsUsingAutoLayout(progressBar, chapterLabel, leftButton, rightButton, labelChapterView)
        addGestureRecognizers()
        layoutViews()
    }
    
    func addGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPressLabel))
        chapterLabel.addGestureRecognizer(tapRecognizer)
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        rightSwipeRecognizer.direction = .right
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        leftSwipeRecognizer.direction = .left
        addGestureRecognizer(rightSwipeRecognizer)
        addGestureRecognizer(leftSwipeRecognizer)
    }
    
    @objc func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            chapterPressDelegate?.didPressNextChapter()
        case .right:
            chapterPressDelegate?.didPressPreviousChapter()
        default:
            print("error swipe")
        }
    }
    
    var labelChapterViewTopAnchor: NSLayoutConstraint?
    var progressBarTrailingAnchor: NSLayoutConstraint?
    
    func layoutViews() {
        progressBar.centerYAnchor.constrain(to: centerYAnchor)
        progressBar.heightAnchor.constrain(to: heightAnchor)
        progressBar.leadingAnchor.constrain(to: leadingAnchor)
        
        chapterLabel.centerXAnchor.constrain(to: centerXAnchor)
        chapterLabel.centerYAnchor.constrain(to: centerYAnchor)
        chapterLabel.heightAnchor.constrain(to: heightAnchor, multiplyBy: 2/3)
        chapterLabel.widthAnchor.constrain(.greaterThanOrEqual, to: 30)
        
        leftButton.centerYAnchor.constrain(to: centerYAnchor)
        leftButton.leadingAnchor.constrain(to: leadingAnchor, with: 8)
        leftButton.heightAnchor.constrain(to: heightAnchor, multiplyBy: 2/3)
        leftButton.widthAnchor.constrain(to: leftButton.heightAnchor)
        
        rightButton.centerYAnchor.constrain(to: centerYAnchor)
        rightButton.trailingAnchor.constrain(to: trailingAnchor, with: -8)
        rightButton.heightAnchor.constrain(to: heightAnchor, multiplyBy: 2/3)
        rightButton.widthAnchor.constrain(to: rightButton.heightAnchor)
        
        labelChapterViewTopAnchor = labelChapterView.topAnchor.constrain(to: bottomAnchor, with: 10)
        labelChapterViewTopAnchor?.isActive = true
        labelChapterView.centerXAnchor.constrain(to: centerXAnchor)
        labelChapterView.widthAnchor.constrain(to: widthAnchor)
        labelChapterView.heightAnchor.constrain(to: heightAnchor)
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
