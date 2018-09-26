//
//  TextParser.swift
//  SearchBible
//
//  Created by Min Kim on 9/26/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

class TextParser {
    
    func parseVerse(for clipboardText: String) -> [String:String] {
        let splitText = clipboardText.components(separatedBy: " ")
        var returnDict = [String: String]()
        returnDict["book"] = calculatebook(for: splitText)
        returnDict["chapter"] = String(calculateChapter(for: splitText))
        returnDict["verse"] = String(calculateVerse(for: splitText))
        return returnDict
    }
    
    func calculatebook(for splitText: [String]) -> String {
        var book = splitText.first!
        book = book.capitalizingFirstLetter()
        return book
    }
    
    func calculateChapter(for splitText: [String]) -> Int {
        var chapter = 1
        if splitText[1].lowercased() == "chapter" {
            if Int(splitText[2]) == nil {
                chapter = returnNumber(for: splitText[2])
            } else {
                chapter = Int(splitText[2])!
            }
        } else {
            if Int(splitText[1]) != nil {
                chapter = Int(splitText[1])!
            } else {
                chapter = returnNumber(for: splitText[1])
            }
        }
        return chapter
    }
    
    func calculateVerse(for splitText: [String]) -> Int {
        var verse = 1
        if splitText[2].lowercased() == "verse" || splitText[2].lowercased() == "verses" {
            if Int(splitText[3]) == nil {
                verse = returnNumber(for: splitText[3])
            } else {
                verse = Int(splitText[3])!
            }
        } else {
            if Int(splitText[4]) != nil {
                verse = Int(splitText[4])!
            } else {
                verse = returnNumber(for: splitText[4])
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
