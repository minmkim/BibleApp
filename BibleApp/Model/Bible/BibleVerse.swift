//
//  BibleVerse.swift
//  BibleApp
//
//  Created by Min Kim on 8/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import CoreData

final class BibleVerse {
    
    let book: String
    let chapter: Int
    let verse: Int
    let text: String
    let version: String
    var isHighlighted: Bool
    
    init(book: String, chapter: Int, verse: Int, text: String, version: String, isHighlighted: Bool = false) {
        self.book = book
        self.chapter = chapter
        self.verse = verse
        self.text = text
        self.version = version
        self.isHighlighted = isHighlighted
    }
    
    init(fetchedVerse: NSManagedObject) {
        self.book = fetchedVerse.value(forKey: CoreDataBible.book) as! String
        self.chapter = fetchedVerse.value(forKey: CoreDataBible.chapter) as! Int
        self.verse = fetchedVerse.value(forKey: CoreDataBible.verse) as! Int
        self.text = fetchedVerse.value(forKey: CoreDataBible.text) as! String
        self.version = fetchedVerse.value(forKey: CoreDataBible.version) as! String
        self.isHighlighted = fetchedVerse.value(forKey: CoreDataBible.isHighlighted) as! Bool
    }
    
    func formattedVerse() -> String {
        switch version {
        case BibleVersions.niv1984:
            return "\(book) \(chapter):\(verse) (NIV)"
        case BibleVersions.KRV:
            return "\(book) \(chapter):\(verse) (KRV)"
        default:
            return "\(book) \(chapter):\(verse)"
        }
        
    }
    
    func formattedVerseAndText() -> String {
        switch version {
        case BibleVersions.niv1984:
            return "\(text)\n\(book) \(chapter):\(verse) (NIV)"
        case BibleVersions.KRV:
            return "\(text)\n\(book) \(chapter):\(verse) (KRV)"
        default:
            return "\(text)\n\(book) \(chapter):\(verse)"
        }
    }
    
}
