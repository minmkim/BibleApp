//
//  SavedVerse.swift
//  BibleApp
//
//  Created by Min Kim on 9/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import CoreData

class SavedVerse {
    
    var book: String
    var chapter: Int
    var verse: Int
    var text: String
    var upToVerse: Int?
    var isMultipleVerses: Bool = false
    
    init(book: String, chapter: Int, verse: Int, text: String, upToVerse: Int? = nil, isMultipleVerses: Bool = false) {
        self.book = book
        self.chapter = chapter
        self.verse = verse
        self.text = text
        self.isMultipleVerses = isMultipleVerses
    }
    
    init?(bibleVerses: [BibleVerse]) {
        let sortedVerses = bibleVerses.sorted(by: {$0.verse < $1.verse})
        switch sortedVerses.count {
        case 0:
            return nil
        case 1:
            guard let firstVerse = sortedVerses.first else {return nil}
            self.book = firstVerse.book
            self.chapter = firstVerse.chapter
            self.verse = firstVerse.verse
            self.text = firstVerse.text
            self.isMultipleVerses = false
        case let x where x > 1:
            let firstVerse = sortedVerses.first!
            self.book = firstVerse.book
            self.chapter = firstVerse.chapter
            self.verse = firstVerse.verse
            isMultipleVerses = true
            let lastVerse = sortedVerses.last!
            self.upToVerse = lastVerse.verse
            var text = ""
            sortedVerses.forEach { (verse) in
                text += "\n\(verse.verse) \(verse.text)"
            }
            text.removeFirst() 
            self.text = text
        default:
            return nil
        }
    }
    
    init(fetchedVerse: NSManagedObject) {
        self.book = fetchedVerse.value(forKey: CoreDataVerse.book) as! String
        self.chapter = fetchedVerse.value(forKey: CoreDataVerse.chapter) as! Int
        self.verse = fetchedVerse.value(forKey: CoreDataVerse.verse) as! Int
        self.text = fetchedVerse.value(forKey: CoreDataVerse.text) as! String
        self.upToVerse = fetchedVerse.value(forKey: CoreDataVerse.upToVerse) as? Int
        self.isMultipleVerses = (fetchedVerse.value(forKey: CoreDataVerse.isMultipleVerses) as? Bool) ?? false
    }
    
    func formattedVerse() -> String {
        return !isMultipleVerses ? "\(book) \(chapter):\(verse)" : "\(book) \(chapter):\(verse)-\(upToVerse ?? 0)"
        
    }
    
    func formattedVerseAndText() -> String {
        return !isMultipleVerses ? "\(text)\n\(book) \(chapter):\(verse)-\(upToVerse ?? 0)" : "\(text)\n\(book) \(chapter):\(verse)"
    }
    
    
}
