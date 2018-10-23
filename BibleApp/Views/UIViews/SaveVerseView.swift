//
//  SaveVerseView.swift
//  BibleApp
//
//  Created by Min Kim on 10/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class SaveVerseView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .red
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 12
        return cv
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    let sectionTextView: UITextView = {
        let st = UITextView()
        st.backgroundColor = .blue
        return st
    }()
    
    let noteTextView: UITextView = {
        let nt = UITextView()
        nt.backgroundColor = .green
        return nt
    }()
    
    let saveButton: UIButton = {
        let sb = UIButton()
        sb.setTitle("Save", for: .normal)
        sb.backgroundColor = .yellow
        return sb
    }()
    
    let cancelButton: UIButton = {
        let cb = UIButton()
        cb.setTitle("Cancel", for: .normal)
        cb.backgroundColor = .white
//        cb.addTarget(self, action: #selector(didPressCancel), for: .touchUpInside)
        return cb
    }()
    
    func setupViews() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(sectionTextView)
        stackView.addArrangedSubview(noteTextView)
        let horizontalStack = UIStackView(arrangedSubviews: [saveButton, cancelButton])
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fillEqually
        stackView.addArrangedSubview(horizontalStack)
        
    }
    
    func layoutViews() {
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
    }
}
