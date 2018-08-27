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
    
    enum IndexState {
        case scrollingTable
        case scrollingIndex
    }
    
    var indexState = IndexState.scrollingTable
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
    
    let bookMarker: UIView = {
        let bm = UIView()
        bm.translatesAutoresizingMaskIntoConstraints = false
        bm.backgroundColor = .black
        bm.layer.cornerRadius = 1
        bm.layer.masksToBounds = true
        return bm
    }()
    
    init(frame: CGRect, indexList: [String], height: CGFloat) {
        super.init(frame: frame)
        self.frameHeight = height
        self.indexList = indexList
        countOfList = indexList.count
        backgroundColor = .clear
        addSubview(containerStack)
        addSubview(bookMarker)
        layoutViews()
        setSkipCounter()
        processList()
    }
    
    func setSkipCounter() {
        if let frameHeight = self.frameHeight {
            let numberOfRows = Int((frameHeight-24)/14)
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
    }
    
    func processList() {
        var tempList = indexList
        tempList = tempList.enumerated().compactMap { index, element in index % skipCounter == 0 ? element : nil }
        if skipCounter > 1 {
            let sep = "\u{2022}"
            tempList = Array(tempList.map { [$0] }.joined(separator: [sep]))
            tempList.removeLast()
            tempList.append(indexList.last!)
        }
        indexList = tempList
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
    var bookMarkerTopAnchor: NSLayoutConstraint?
    var bookMarkerBottomAnchor: NSLayoutConstraint?
    
    func layoutViews() {
        stackTopAnchor = containerStack.topAnchor.constraint(equalTo: topAnchor)
        stackTopAnchor?.isActive = true
        containerStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackBottomAnchor = containerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        stackBottomAnchor?.isActive = true
        
        bookMarker.heightAnchor.constraint(equalToConstant: 2).isActive = true
        bookMarker.widthAnchor.constraint(equalTo: containerStack.widthAnchor, multiplier: 1/4).isActive = true
        bookMarker.leadingAnchor.constraint(equalTo: containerStack.leadingAnchor).isActive = true
        bookMarkerTopAnchor = bookMarker.topAnchor.constraint(equalTo: containerStack.topAnchor, constant: (34/3)/2)
        bookMarkerTopAnchor?.isActive = true
    }
    
    override func layoutSubviews() {
    }
    
    func updatePositionOfBookMarker(index: Int) {
        if !didCalculateHeightOfMarker {
            calculateHeightOfMarker()
        }
        bookMarkerBottomAnchor?.isActive = false
        bookMarkerTopAnchor?.isActive = false
        switch index {
        case 0:
            bookMarkerTopAnchor = bookMarker.topAnchor.constraint(equalTo: containerStack.topAnchor, constant: CGFloat(heightOfMarker/2))
            bookMarkerTopAnchor?.isActive = true
        case countOfList - 1:
            bookMarkerBottomAnchor = bookMarker.bottomAnchor.constraint(equalTo: containerStack.bottomAnchor, constant: CGFloat(-heightOfMarker/2))
            bookMarkerBottomAnchor?.isActive = true
        default:
            if skipCounter == 1 {
                let height = (Double(index) * Double(heightOfMarker)) + Double(heightOfMarker/2) + (Double(index*2))
                bookMarkerTopAnchor = bookMarker.topAnchor.constraint(equalTo: containerStack.topAnchor, constant: CGFloat(height))
                bookMarkerTopAnchor?.isActive = true
            } else {
                print(index%skipCounter)
                if index%skipCounter == 0 {
                    let calculatedIndex = Double(index)/Double(skipCounter)
                    let heightOfJustIndexes = ((Double(calculatedIndex) * 2 * Double(heightOfMarker)) + Double(heightOfMarker)/2)
                    let numberOfSpacers = Double((calculatedIndex) * 4)
                    let heightWithSpacers: Double = heightOfJustIndexes + (numberOfSpacers * 2)
                    bookMarkerTopAnchor = bookMarker.topAnchor.constraint(equalTo: containerStack.topAnchor, constant: CGFloat(heightWithSpacers))
                    bookMarkerTopAnchor?.isActive = true
                } else {
                    let calculatedIndex = Double(index)/Double(skipCounter)
                    let heightOfJustIndexes = (calculatedIndex * 2 * Double(heightOfMarker)) + Double(heightOfMarker/2)
                    let numberOfSpacers = Double((calculatedIndex) * 4)
                    let heightWithSpacers: Double = heightOfJustIndexes + (numberOfSpacers * 2)
                    bookMarkerTopAnchor = bookMarker.topAnchor.constraint(equalTo: containerStack.topAnchor, constant: CGFloat(heightWithSpacers))
                    bookMarkerTopAnchor?.isActive = true
                }
            }
        }
        layoutIfNeeded()
    }
    var heightOfMarker:CGFloat = 0 {
        didSet {
            if heightOfMarker != 0 {
                didCalculateHeightOfMarker = true
            }
        }
    }
    var didCalculateHeightOfMarker = false
    
    func calculateHeightOfMarker() {
        let height = self.containerStack.bounds.maxY - self.containerStack.bounds.minY
        if height == 0 {
            return
        }
        let numberOfRows = indexList.count
        if skipCounter == 1 {
            let heightOfGaps = Double(numberOfRows-1) * 2
            let heightOfNamesAndDots = Double(height) - Double(heightOfGaps)
            heightOfMarker = CGFloat(heightOfNamesAndDots / Double(numberOfRows))
        } else {
            let heightOfGaps = Double(numberOfRows-1) * 4
            let heightOfNamesAndDots = Double(height) - Double(heightOfGaps)
            heightOfMarker = CGFloat(heightOfNamesAndDots / Double(numberOfRows))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentIndex = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        indexState = .scrollingIndex
        layoutIfNeeded()
        if let touch = touches.first {
            let currentPoint = touch.location(in: containerStack)
            moveMarkerWithIndexTouch(for: currentPoint)
            let index = calculateIndex(at: currentPoint)
            if currentIndex != index {
                currentIndex = index
                delegate?.pressedIndex(at: index)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        indexState = .scrollingIndex
        layoutIfNeeded()
        if let touch = touches.first {
            let currentPoint = touch.location(in: containerStack)
            moveMarkerWithIndexTouch(for: currentPoint)
            let index = calculateIndex(at: currentPoint)
            if currentIndex != index {
                currentIndex = index
                delegate?.pressedIndex(at: index)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        indexState = .scrollingTable
        if let touch = touches.first {
            let currentPoint = touch.location(in: containerStack)
            let index = calculateIndex(at: currentPoint)
            if currentIndex != index {
                currentIndex = index
                delegate?.pressedIndex(at: index)
            }
        }
    }
    
    func moveMarkerWithIndexTouch(for location: CGPoint) {
        if location.y > self.containerStack.bounds.maxY - 6 || location.y < self.containerStack.bounds.minY {
            return
        }
        bookMarkerBottomAnchor?.isActive = false
        bookMarkerTopAnchor?.isActive = false
        bookMarkerTopAnchor = bookMarker.topAnchor.constraint(equalTo: containerStack.topAnchor, constant: location.y)
        bookMarkerTopAnchor?.isActive = true
        layoutIfNeeded()
    }
    
    func calculateIndex(at location: CGPoint) -> Int {
        let yFrame = self.containerStack.bounds.maxY - self.containerStack.bounds.minY
        let index = Int(Float(location.y/yFrame) * Float(countOfList))
        return index
    }
    
    
}
