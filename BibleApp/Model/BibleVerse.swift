//
//  BibleVerse.swift
//  BibleApp
//
//  Created by Min Kim on 8/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BibleVerse {
    
    var book: String
    var chapter: Int
    var verse: Int
    var text: String
    
    init(book: String, chapter: Int, verse: Int, text: String) {
        self.book = book
        self.chapter = chapter
        self.verse = verse
        self.text = text
    }
    
    init(fetchedVerse: NSManagedObject) {
        self.book = fetchedVerse.value(forKey: CoreDataVerse.book) as! String
        self.chapter = fetchedVerse.value(forKey: CoreDataVerse.chapter) as! Int
        self.verse = fetchedVerse.value(forKey: CoreDataVerse.verse) as! Int
        self.text = fetchedVerse.value(forKey: CoreDataVerse.text) as! String
    }
    
    let dataManager = VersesDataManager()
    
    func saveToCoreData() {
        dataManager.saveToCoreData(bibleVerse: self)
    }
    
}
