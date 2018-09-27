//
//  TextParser.swift
//  SearchBible
//
//  Created by Min Kim on 9/26/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

class TextParser {
    
    enum TypeOfBook {
        case numberBook
        case regularBook
    }
    
    var typeOfBook = TypeOfBook.regularBook
    
    func parseVerse(for clipboardText: String) -> [String:String] {
        let splitText = clipboardText.components(separatedBy: " ")
        var returnDict = [String: String]()
        returnDict["book"] = calculatebook(for: splitText)
        returnDict["chapter"] = String(calculateChapter(for: splitText))
        returnDict["verse"] = String(calculateVerse(for: splitText))
        return returnDict
    }
    
    var bookNumberNames = ["first", "1st", "1", "second", "2nd", "2", "third", "3rd", "3"]
    
    func calculatebook(for splitText: [String]) -> String {
        
        if bookNumberNames.contains(splitText[0].lowercased()) {
            guard let index = bookNumberNames.firstIndex(of: splitText[0].lowercased()) else { fatalError()}
            typeOfBook = .numberBook
            switch index {
            case 0...2:
                return "1 \(splitText[1])"
            case 3...5:
                return "2 \(splitText[1])"
            case 6...8:
                return "3 \(splitText[1])"
            default:
                print("error")
            }
        }
        
        var book = splitText.first!
        book = book.capitalizingFirstLetter()
        return book
    }
    
    func calculateChapter(for splitText: [String]) -> Int {
        var index = 1
        if typeOfBook == .numberBook {
            index += 1
        }
        
        var chapter = 1
        if splitText[index].lowercased() == "chapter" {
            if Int(splitText[index + 1]) == nil {
                chapter = returnNumber(for: splitText[index + 1])
            } else {
                chapter = Int(splitText[index + 1])!
            }
        } else {
            if Int(splitText[index + 1]) != nil {
                chapter = Int(splitText[index])!
            } else {
                chapter = returnNumber(for: splitText[index])
            }
        }
        return chapter
    }
    
    func calculateVerse(for splitText: [String]) -> Int {
        var index = 2
        if typeOfBook == .numberBook {
            index += 1
        }
        var verse = 1
        if splitText[index].lowercased() == "verse" || splitText[index].lowercased() == "verses" {
            if Int(splitText[index + 1]) == nil {
                verse = returnNumber(for: splitText[3])
            } else {
                verse = Int(splitText[index + 1])!
            }
        } else {
            if Int(splitText[index + 2]) != nil {
                verse = Int(splitText[index + 2])!
            } else {
                verse = returnNumber(for: splitText[index + 2])
            }
        }
        return verse
    }
    
    func returnNumber(for text: String) -> Int {
        var number = 1
        switch text.lowercased() {
        case "one":
            number = 1
        case "two":
            number = 2
        case "three":
            number = 3
        case "four":
            number = 4
        case "five":
            number = 5
        case "six":
            number = 6
        case "seven":
            number = 7
        case "eight":
            number = 8
        case "nine":
            number = 9
        case "ten":
            number = 10
        default:
            print("default chapter")
        }
        return number
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
