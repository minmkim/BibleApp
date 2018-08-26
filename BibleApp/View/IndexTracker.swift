//
//  IndexTracker.swift
//  BibleApp
//
//  Created by Min Kim on 8/25/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

protocol IndexListDelegate: class {
    func pressedIndex(at index: Int)
}

class IndexTracker: UIView {
    
    var indexList = [String]()
    weak var delegate: IndexListDelegate?
    var frameHeight: CGFloat?
    var skipCounter = 1
    var countOfList = 0
    
    let containerStack: UIStackView = {
        let cv = UIStackView()
        cv.axis = .vertical
        cv.distribution = .fillEqually
        cv.alignment = .center
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.spacing = 2
        return cv
    }()
    
    init(frame: CGRect, indexList: [String], height: CGFloat) {
        super.init(frame: frame)
        self.frameHeight = height
        self.indexList = indexList
        countOfList = indexList.count
        backgroundColor = .white
        addSubview(containerStack)
        layoutViews()
        if let frameHeight = self.frameHeight {
            let numberOfRows = Int((frameHeight-24)/14)
            print(indexList.count)
            print(numberOfRows)
            print(frameHeight)
            var testing = false
            while !testing {
                if skipCounter == 1 {
                    if indexList.count > numberOfRows {
                        skipCounter += 1
                    } else {
                        testing = true
                    }
                } else {
                    if (indexList.count/skipCounter) * 2 > numberOfRows {
                        skipCounter += 1
                    } else {
                        testing = true
                    }
                }
            }
        }
        processList()
    }
    
    func processList() {
        var newList = indexList
        newList = newList.enumerated().compactMap { index, element in index % skipCounter == 0 ? element : nil }
        if skipCounter > 1 {
            let sep = "\u{2022}"
            newList = Array(newList.map { [$0] }.joined(separator: [sep]))
            newList.removeLast()
            newList.append(indexList.last!)
        }
        indexList = newList
        indexList.forEach { (index) in
            let label = UILabel()
            label.font = .systemFont(ofSize: 11, weight: .heavy)
            label.textColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
            label.text = index
            containerStack.addArrangedSubview(label)
        }
    }
    
    func setFrame(frameHeight: CGFloat) {
        let count = indexList.count
        let height = CGFloat(14*count)
        if height < (frameHeight - 24) {
            stackTopAnchor?.isActive = false
            stackBottomAnchor?.isActive = false
            stackHeightAnchor = containerStack.heightAnchor.constraint(equalToConstant: height)
            stackHeightAnchor?.isActive = true
            stackCenterYAnchor = containerStack.centerYAnchor.constraint(equalTo: centerYAnchor)
            stackCenterYAnchor?.isActive = true
            self.layoutIfNeeded()
        }
        
    }
    
    var stackHeightAnchor: NSLayoutConstraint?
    var stackTopAnchor: NSLayoutConstraint?
    var stackBottomAnchor: NSLayoutConstraint?
    var stackCenterYAnchor: NSLayoutConstraint?
    
    
    func layoutViews() {
        stackTopAnchor = containerStack.topAnchor.constraint(equalTo: topAnchor)
        stackTopAnchor?.isActive = true
        containerStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackBottomAnchor = containerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        stackBottomAnchor?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentIndex = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: containerStack)
            let index = calculateIndex(at: currentPoint)
            if currentIndex != index {
                currentIndex = index
                delegate?.pressedIndex(at: index)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: containerStack)
            let index = calculateIndex(at: currentPoint)
            if currentIndex != index {
                currentIndex = index
                delegate?.pressedIndex(at: index)
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: containerStack)
            let index = calculateIndex(at: currentPoint)
            if currentIndex != index {
                currentIndex = index
                delegate?.pressedIndex(at: index)
            }
        }
    }
    
    func calculateIndex(at location: CGPoint) -> Int {
        let yFrame = self.containerStack.frame.maxY - self.containerStack.frame.minY
        let index = Int(Float(location.y/yFrame) * Float(countOfList))
        print(index)
        return index
    }
    
    
}
