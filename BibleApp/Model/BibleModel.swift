
//
//  BibleModel.swift
//  BibleApp
//
//  Created by Min Kim on 8/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

class Bible {
    
    let booksOfOldTestament = [genesis, exodus, leviticus, numbers, deuteronomy, joshua, judges, firstSamuel, secondSamuel, firstKings, secondKings, firstChronicles, secondChronicles, ruth, ezra, nehemiah, esther, job, psalms, proverbs, ecclesiastes, songOfSongs, isaiah, jeremiah, lamentations, ezekiel, daniel, hosea, joel, amos, obadiah, jonah, micah, nahum, habakkuk, zephaniah, haggai, zechariah, malachi]
    
    let booksOfNewTestament = [matthew, mark, luke, john, acts, romans, firstCorinthians, secondCorinthians, galatians, ephesians, philippians, colossians, firstThessalonians, secondThessalonians, firstTimothy, secondTimothy, titus, philemon, hebrews, james, firstPeter, secondPeter, firstJohn, secondJohn, thirdJohn, jude, revelation]
    
    let booksOfOldTestamentStrings = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Songs", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"]
    
    let booksOfNewTestamentStrings = ["Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    
    var bookVerseDictionary = [String:[Int:[String]]]()
    var bible = [String: [BibleVerse]]()
    
    init() {
        let didCreateCoreDataBible = UserDefaults.standard.bool(forKey: "didCreateCoreDataBible")
        if !didCreateCoreDataBible {
            var oldCounter = 0
            var newCounter = 0
            DispatchQueue.main.async { // 1
                self.booksOfOldTestament.forEach { (book) in
                    self.bookVerseDictionary[self.booksOfOldTestamentStrings[oldCounter]] = self.createBookDictionary(book)
                    oldCounter += 1
                }
                self.booksOfNewTestament.forEach { (book) in
                    self.bookVerseDictionary[self.booksOfNewTestamentStrings[newCounter]] = self.createBookDictionary(book)
                    newCounter += 1
                }
                self.createCoreDatabible()
            }
            UserDefaults.standard.set(true, forKey: "didCreateCoreDataBible")
        } else {
            loadBible()
        }
        
        
    }
    
    private func removeNumber(_ verse: String) -> String {
        if let _ = Int(verse.prefix(3)) {
            return String(verse.dropFirst(3))
        } else if let _ = Int(verse.prefix(2)) {
            return String(verse.dropFirst(2))
        } else {
            return String(verse.dropFirst(1))
        }
    }
    
    private func createBookDictionary(_ book: String) -> [Int:[String]] {
        let bookArray = book.components(separatedBy: "\n")
        var currentChapter = 1
        var versesInchapterArray = [String]()
        var bookDict = [Int:[String]]()
        var counter = 0
        var isNewchapter = false
        var firstVerseOfSecondChapterCounter = 0
        
        bookArray.forEach { (verse) in
            
            counter += 1

            if isNewchapter {
                bookDict[currentChapter] = versesInchapterArray
                currentChapter += 1
                versesInchapterArray = []
                versesInchapterArray.append(removeNumber(verse))
                isNewchapter = false
            } else if !isNewchapter && counter == bookArray.count {
                versesInchapterArray.append(removeNumber(verse))
                bookDict[currentChapter] = versesInchapterArray
            } else {
                versesInchapterArray.append(removeNumber(verse))
            }
            
            //check if the current verse is 1
            if counter < bookArray.count - 1 {
                if let _ = Int(bookArray[counter + 1].prefix(3)) {
                } else if let _ = Int(bookArray[counter + 1].prefix(2)) {
                } else {
                    if let checkNumber = Int(bookArray[counter + 1].prefix(1)) {
                        if checkNumber == 2 && firstVerseOfSecondChapterCounter == 1 {
                            isNewchapter = true
                        } else if checkNumber == 2 && currentChapter == 1 {
                            firstVerseOfSecondChapterCounter += 1
                        }
                    }
                }
            }
        }
        return bookDict
    }
    
    lazy var verseDataManager = VersesDataManager()
    
    private func createCoreDatabible() {
        bookVerseDictionary.forEach { (book, chapterVerse) in
            for (chapter, verses) in chapterVerse {
                var verseCounter = 0
                for text in verses {
                    verseCounter += 1
                    let bibleVerse = BibleVerse(book: book, chapter: chapter, verse: verseCounter, text: text)
                    verseDataManager.createBible(bibleVerse: bibleVerse)
                }
            }
        }
    }
    
    private func loadBible() {
        let bibleVerses = verseDataManager.loadBible()
        bibleVerses.forEach { (bibleVerse) in
            var bibleVerseArray = [BibleVerse]()
            bibleVerseArray = bible[bibleVerse.book] ?? []
            bibleVerseArray.append(bibleVerse)
            bible[bibleVerse.book] = bibleVerseArray
        }
    }
    
}
