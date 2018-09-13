//
//  HeaderView.swift
//  BibleApp
//
//  Created by Min Kim on 8/26/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var chapter: Int! {
        didSet {
            chapterLabel.text = "CHAPTER \(chapter + 1)"
        }
    }
    
    let progressBar: UIView = {
       let pb = UIView()
        pb.translatesAutoresizingMaskIntoConstraints = false
        pb.backgroundColor = MainColor.redOrange
        pb.alpha = 0.1
        return pb
    }()
    
    let chapterLabel: UILabel = {
        let cl = UILabel()
        cl.font = .preferredFont(forTextStyle: .headline)
        cl.adjustsFontForContentSizeCategory = true
        cl.textColor = .black
        cl.translatesAutoresizingMaskIntoConstraints = false
        return cl
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(containerView)
        containerView.addSubview(chapterLabel)
        containerView.addSubview(progressBar)
        layoutHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var multipler: Double = 0.0
    
    func updateProgressBar(multipler: Double) {
        if multipler != self.multipler {
            self.multipler = multipler
            let frame = self.frame.width
            let constant = Double(frame) * multipler
            progressBarTrailingAnchor?.isActive = false
            progressBarTrailingAnchor = progressBar.trailingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(constant))
            progressBarTrailingAnchor?.isActive = true
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    
    var progressBarTrailingAnchor: NSLayoutConstraint?
    
    func layoutHeader() {
        containerView.fillContainer(for: self)
        
        progressBar.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        progressBar.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        progressBarTrailingAnchor = progressBar.trailingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -20)
        progressBarTrailingAnchor?.isActive = true
        
        chapterLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        chapterLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        chapterLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    }
}
