
//
//  BibleModel.swift
//  BibleApp
//
//  Created by Min Kim on 8/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

final class Bible {
    
    typealias Book = String
    typealias Chapter = Int
    typealias VerseText = String
    
    private let booksOfOldTestament = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Songs", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"]
    
    private let booksOfNewTestament = ["Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    
    private let verseDataManager: VersesDataManager!
    private let countOfOldTestament = 39
    private let countOfNewTestament = 27
    
    init(verseDataManager: VersesDataManager) {
        self.verseDataManager = verseDataManager
    }
    
    func getBibleBook(_ book: String, forChapter chapter: Int, version: String, completion: ([BibleVerse]) -> Void) {
        verseDataManager.loadBibleBook(book, forChapter: chapter, version: version) { (fetchedVerses) in
            completion(fetchedVerses)
        }
    }
    
    func bibleDoesContainBook(for book: Book) -> Bool {
        let isOldTestament = booksOfOldTestament.contains { $0.lowercased() == book.lowercased() }
        let isNewTestament = booksOfNewTestament.contains { $0.lowercased() == book.lowercased() }
        
        return (isOldTestament || isNewTestament)
    }
    
    func numberOfChaptersInBook(for book: Book) -> Int? {
        guard let index = Constants.bookStrings.firstIndex(of: book) else {return nil}
        return index < 66 ? Constants.numberOfChaptersInBibleBooks[index] : nil
    }
    
    func numberOfVersesInBookChapterFor(book: Book, chapter: Chapter, version: String, completion: (Int) -> Void) {
        verseDataManager.getVerseCountFor(book: book, chapter: chapter, version: version) { (countOfVerses) in
            completion(countOfVerses)
        }
    }
    
    func returnBook(for index: Int) -> String {
        switch index {
        case (0..<countOfOldTestament):
            return booksOfOldTestament[index]
        case (countOfOldTestament...(countOfOldTestament+countOfNewTestament)):
            return booksOfNewTestament[index - countOfOldTestament]
        default:
            fatalError("tried to return book outside of range of bible")
        }
    }
    
    func bookIndex(for book: Book) -> Int? {
        if let index = booksOfOldTestament.firstIndex(of: book) {
            return index
        }
        if let index = booksOfNewTestament.firstIndex(of: book) {
            return index + countOfOldTestament
        }
        return nil
    }
    
    func returnNextBook(for index: Int) -> String? {
        let newIndex = index + 1
        switch newIndex {
        case (0..<countOfOldTestament):
            return booksOfOldTestament[newIndex]
        case (countOfOldTestament..<(countOfOldTestament+countOfNewTestament)):
            return booksOfNewTestament[newIndex - 39]
        default:
            return nil
        }
    }
    
    func returnPreviousBook(for index: Int) -> String? {
        let newIndex = index - 1
        switch newIndex {
        case (0..<countOfOldTestament):
            return booksOfOldTestament[newIndex]
        case (countOfOldTestament..<(countOfOldTestament+countOfNewTestament)):
            return booksOfNewTestament[newIndex - 39]
        default:
            return nil
        }
    }
    
    func searchBibleForWords(_ searchWord: String, withOffset: Int, completion: ([BibleVerse]) -> Void) {
        let version = UserDefaults.standard.string(forKey: "BibleVersion") ?? "NIV1984"
        verseDataManager.searchForWord(searchWord: searchWord, version: version, fetchOffset: withOffset, completion: {completion($0)})
    }
    
}
