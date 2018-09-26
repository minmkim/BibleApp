//
//  SearchBibleIntentHandler.swift
//  SearchBible
//
//  Created by Min Kim on 9/25/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class IntentBible {
    
    let booksOfOldTestament = [genesis, exodus, leviticus, numbers, deuteronomy, joshua, judges, firstSamuel, secondSamuel, firstKings, secondKings, firstChronicles, secondChronicles, ruth, ezra, nehemiah, esther, job, psalms, proverbs, ecclesiastes, songOfSongs, isaiah, jeremiah, lamentations, ezekiel, daniel, hosea, joel, amos, obadiah, jonah, micah, nahum, habakkuk, zephaniah, haggai, zechariah, malachi]
    
    let booksOfNewTestament = [matthew, mark, luke, john, acts, romans, firstCorinthians, secondCorinthians, galatians, ephesians, philippians, colossians, firstThessalonians, secondThessalonians, firstTimothy, secondTimothy, titus, philemon, hebrews, james, firstPeter, secondPeter, firstJohn, secondJohn, thirdJohn, jude, revelation]
    
    let booksOfOldTestamentStrings = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Songs", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"]
    
    let booksOfNewTestamentStrings = ["Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    
    var bookVerseDictionary = [String:[Int:[String]]]()
    
    init() {

    }
    
    func createBible(book: String) {
        if booksOfNewTestamentStrings.contains(book) {
            guard let index = booksOfNewTestamentStrings.firstIndex(of: book) else {return}
            bookVerseDictionary[book] = createBookDictionary(booksOfNewTestament[index])
        } else {
            guard let index = booksOfOldTestamentStrings.firstIndex(of: book) else {return}
            bookVerseDictionary[book] = createBookDictionary(booksOfOldTestament[index])
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
    
    func createBookDictionary(_ book: String) -> [Int:[String]] {
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
    
}


@available(iOS 12.0, *)
class SearchBibleIntentHandler: NSObject, SearchBibleIntentIntentHandling {
    
    let bible = IntentBible()
    
    func handle(intent: SearchBibleIntentIntent, completion: @escaping (SearchBibleIntentIntentResponse) -> Void) {
        guard let pastedText = UIPasteboard.general.string else {return}
        let splitText = pastedText.components(separatedBy: " ")
        
        // 2
        let book = splitText[1]
        guard let chapter = Int(splitText[3]) else {return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))}
        guard let verse = Int(splitText[5]) else {return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))}
        
        
//        guard let book = intent.book else {
//                return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))
//        }
        bible.createBible(book: book)
//
//        guard let chapter = intent.chapter as? Int else {
//            return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))
//        }
//
//        guard let verse = intent.verse as? Int else {
//            return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))
//        }
        
        guard let bookChapterVerse = bible.bookVerseDictionary[book] else {
            return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))
        }
        
        guard let chapterVerse = bookChapterVerse[chapter] else {
            return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))
        }
        
        if chapterVerse.count > (verse - 1) {
            let text = chapterVerse[verse - 1]
            UIPasteboard.general.string = text
            return completion(SearchBibleIntentIntentResponse.success(bibleVerse: text))
        } else {
            return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))
        }
        
        
    }
    
}
