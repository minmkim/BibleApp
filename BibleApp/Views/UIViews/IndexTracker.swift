//
//  IndexTracker.swift
//  BibleApp
//
//  Created by Min Kim on 8/25/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

final class IndexTracker: UIView {
    
    enum IndexState {
        case scrollingTable
        case scrollingIndex
    }
    
    var indexState = IndexState.scrollingTable
    var indexList = [String]()
    weak var delegate: IndexListDelegate?
    var frameHeight: CGFloat?
    var skipCounter = 1
    var countOfList = 0 // used for original count of list
    var currentIndex = 0
    var heightOfMarker:CGFloat = 0 {
        didSet {
            if heightOfMarker != 0 {
                didCalculateHeightOfMarker = true
            }
        }
    }
    var didCalculateHeightOfMarker = false
    var bookMarkerTopAnchor: NSLayoutConstraint?
    var bookMarkerBottomAnchor: NSLayoutConstraint?
    
    var containerStack: UIStackView = {
        let cv = UIStackView()
        cv.axis = .vertical
        cv.distribution = .fillEqually
        cv.alignment = .center
        cv.spacing = 2
        return cv
    }()
    
    let bookMarker: UIView = {
        let bm = UIView()
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
        addSubviewsUsingAutoLayout(containerStack, bookMarker)
        setUpViews()
    }
    
    func setUpViews() {
        layoutViews()
        setSkipCounter()
        processList()
        setUpContainerStack()
    }
    
    func setSkipCounter() {
        if let frameHeight = self.frameHeight {
            skipCounter = 1
            let numberOfRows = Int((frameHeight-24)/14) // number of possible rows
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
    
    func newChapter(for arrayList: [String]) {
        indexList =  arrayList
        countOfList = indexList.count
        didCalculateHeightOfMarker = false
        setSkipCounter()
        processList()
        setUpContainerStack()
    }
    
    func processList() {
        var tempList = indexList
        tempList = tempList.enumerated().compactMap { index, element in index % skipCounter == 0 ? element : nil }
        if skipCounter > 1 {
            let separator = "\u{2022}" //dot symbol
            tempList = Array(tempList.map { [$0] }.joined(separator: [separator]))
            tempList.removeLast()
            tempList.append(indexList.last!) // make sure the last element in array is the last element
        }
        indexList = tempList
    }
    
    func setUpContainerStack() {
        containerStack.removeSubViews()
        indexList.forEach { (index) in
            let label = UILabel()
            label.font = .systemFont(ofSize: 11, weight: .heavy)
            label.textColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
            label.text = index
            containerStack.addArrangedSubview(label)
        }
    }
    
    func layoutViews() {
        containerStack.leadingAnchor.constrain(to: leadingAnchor)
        containerStack.trailingAnchor.constrain(to: trailingAnchor)
        containerStack.centerYAnchor.constrain(to: centerYAnchor)
        bookMarker.heightAnchor.constrain(to: 2)
        bookMarker.widthAnchor.constrain(to: containerStack.widthAnchor, multiplyBy: 1/4)
        bookMarker.leadingAnchor.constrain(to: containerStack.leadingAnchor)
        bookMarkerTopAnchor = bookMarker.topAnchor.constrain(to: containerStack.topAnchor, with: ((34/3)/2))
        bookMarkerTopAnchor?.isActive = true
    }
    
    func updatePositionOfBookMarker(index: Int) {
        guard currentIndex != index else { return }
        
        currentIndex = index
        if !didCalculateHeightOfMarker {
            calculateHeightOfMarker()
        }
        var generator: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
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
        generator?.prepare()
        generator?.selectionChanged()
        generator = nil
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    func calculateHeightOfMarker() {
        let height = self.containerStack.bounds.maxY - self.containerStack.bounds.minY
        let numberOfRows = indexList.count
        if height == 0 {
            return
        }
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

extension UIStackView {
    func removeSubViews() {
        for item in arrangedSubviews {
            removeArrangedSubview(item)
            item.removeFromSuperview()
        }
    }
}
