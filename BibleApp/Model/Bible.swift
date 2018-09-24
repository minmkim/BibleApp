
//
//  BibleModel.swift
//  BibleApp
//
//  Created by Min Kim on 8/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

final class Bible {
    
    let booksOfOldTestament = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Songs", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"]
    
    let booksOfNewTestament = ["Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    
    var bible = [String: [Int:[String]]](minimumCapacity: 66)
    
    init() {
        let verseDataManager = VersesDataManager()
        let didCreateCoreDataBible = UserDefaults.standard.bool(forKey: "didCreateCoreDataBible")
        if !didCreateCoreDataBible {
            verseDataManager.preloadDBData()
            UserDefaults.standard.set(true, forKey: "didCreateCoreDataBible")
            loadBible(verseDataManager: verseDataManager)
        } else {
            loadBible(verseDataManager: verseDataManager)
        }
        
    }
    
    private func loadBible(verseDataManager: VersesDataManager) {
        let bibleVerses = verseDataManager.loadBible()
        bibleVerses.forEach { (bibleVerse) in
            if var chapterVerseArray = bible[bibleVerse.book] {
                if var verseArray = chapterVerseArray[bibleVerse.chapter] {
                    verseArray.append(bibleVerse.text)
                    chapterVerseArray[bibleVerse.chapter] = verseArray
                    bible[bibleVerse.book] = chapterVerseArray
                } else {
                    chapterVerseArray[bibleVerse.chapter] = [bibleVerse.text]
                    bible[bibleVerse.book] = chapterVerseArray
                }
            } else {
                bible[bibleVerse.book] = [bibleVerse.chapter:[bibleVerse.text]]
            }
        }
    }
    
}
