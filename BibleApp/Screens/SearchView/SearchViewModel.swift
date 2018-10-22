//
//  SearchViewModel.swift
//  BibleApp
//
//  Created by Min Kim on 8/18/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import Intents
import UIKit

class SearchViewModel {
    
    enum SearchParameter {
        case empty
        case book
        case chapter
        case verse
    }
    
    enum SearchState {
        case verse
        case word
    }
    
    
    weak var bible: Bible!
    var searchParameter: SearchParameter = .empty {
        didSet {
            if searchParameter == .empty {
                fetchOffset = 0
                searchedVerses.removeAll()
                searchWordDelegate?.didFinishSearching()
            }
        }
    }
    var searchState: SearchState = .verse
    weak var verseDataManager: VersesDataManager!
    
    var bookStrings = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Songs", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi", "Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    var filteredBooks = [String]()
    var filteredChapters = [Int]()
    var filteredVerses = [Int]()
    var searchedVerses = [BibleVerse]()
    var fetchOffset = 0
    
    weak var searchWordDelegate: SearchWordDelegate?
    weak var searchBibleDelegate: SearchBibleDelegate?
    
    init(bible: Bible, verseDataManager: VersesDataManager) {
        self.bible = bible
        self.verseDataManager = verseDataManager
    }
    
    func emptyFiltered() {
        filteredBooks.removeAll()
        filteredChapters.removeAll()
        filteredVerses.removeAll()
    }
    
    func setContextOfSearch(_ search: String) {
        if search.count == 0 {
            searchParameter = .empty
            emptyFiltered()
            return
        }
        
        if search.contains(":") {
            searchParameter = .verse
            return
        }
        
        if search.contains(" ") {
            guard let firstChar = search.first else {return}
            if firstChar == "1" || firstChar == "2" {
                let splitText = search.components(separatedBy: " ")
                switch splitText.count {
                case 1: //just the number of the book
                    searchParameter = .book
                case 2: //number + name
                    searchParameter = .book
                case 3: //number + name + chapter
                    searchParameter = .chapter
                default:
                    searchParameter = .book
                }
            } else {
                searchParameter = .chapter
            }
        } else {
            searchParameter = .book
        }
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        var checkText = searchText
        checkText = removeBeginningWhiteSpace(checkText)
        setContextOfSearch(checkText)
        
        let splitText = checkText.components(separatedBy: " ")
        var bibleBook = splitText[0]
        if (splitText[0] == "1" || splitText[0] == "2") && (splitText.count > 1) {
            bibleBook = splitText[0] + " " + splitText[1]
        }
        
        switch searchParameter {
        case .empty:
            return
        case .book:
            filteredBooks = bookStrings.filter({ (book) -> Bool in
                return book.lowercased().contains(bibleBook.lowercased())
            })
        case .chapter:
            if filteredBooks.count != 0 {
                guard let numberOfChapters = bible.numberOfChaptersInBook(for: filteredBooks[0]) else {return}
                filteredChapters = Array(1...numberOfChapters)
                
                if splitText.count == 2 {
                    guard let filteredChapter = Int(splitText[1]) else {return}
                    filteredChapters = filteredChapters.filter({String($0).contains(String(filteredChapter))})
                } else if splitText.count >= 3 {
                    guard let filteredChapter = Int(splitText[2]) else {return}
                    filteredChapters = filteredChapters.filter({String($0).contains(String(filteredChapter))})
                }
            }
        case .verse:
            var splitChapterVerse = [String]()
            if splitText.count < 3 {
                splitChapterVerse = splitText[1].components(separatedBy: ":")
                guard let chapter = Int(splitChapterVerse[0]) else {return}
                filteredChapters = [chapter]
            } else if splitText.count == 3 { //any book with a number
                splitChapterVerse = splitText[2].components(separatedBy: ":")
                guard let chapter = Int(splitChapterVerse[0]) else {return}
                filteredChapters = [chapter]
            } else if splitText.count == 4 { //Song of songs
                splitChapterVerse = splitText[3].components(separatedBy: ":")
                guard let chapter = Int(splitChapterVerse[0]) else {return}
                filteredChapters = [chapter]
            }
           
            if filteredBooks.count != 0 {
                guard let book = bible.returnBookDict(for: filteredBooks[0]) else {return}
                guard let verses = book[filteredChapters[0]] else {return}
                filteredVerses = Array(1...verses.count)
                guard let filteredVerse = Int(splitChapterVerse[1]) else {return}
                filteredVerses = filteredVerses.filter({String($0).contains(String(filteredVerse))})
            }
        }
    }
    
    func getNumberOfRowsInSection() -> Int {
        if searchState == .verse {
            switch searchParameter {
            case .empty:
                return bookStrings.count
            case .book:
                return filteredBooks.count
            case .chapter:
                return filteredChapters.count
            case .verse:
                return filteredVerses.count
            }
        } else {
            return searchedVerses.count
        }
        
    }
    
    func getTextLabel(for index: Int) -> String {
        if searchState == .verse {
            switch searchParameter {
            case .empty:
                return bookStrings[index]
            case .book:
                return filteredBooks[index]
            case .chapter:
                return String(filteredChapters[index])
            case .verse:
                return String(filteredVerses[index])
            }
        } else {
            return searchedVerses[index].formattedVerse()
        }
    }
    
    func removeBeginningWhiteSpace(_ text: String) -> String {
        var returnString = text
        while text.first == " " {
            returnString = String(text.dropFirst())
        }
        return returnString
    }
    
    func didSelectItem(at index: Int, number: Int?) -> String {
        if searchState == .verse {
            switch searchParameter {
            case .empty:
                filteredBooks = [bookStrings[index]]
                return "\(bookStrings[index]) "
            case .book:
                filteredBooks = [filteredBooks[index]]
                return "\(filteredBooks[0]) "
            case .chapter:
                if let number = number {
                    filteredChapters = [number]
                }
                return "\(filteredBooks[0]) \(filteredChapters[0]):"
            case .verse:
                guard let number = number else {return ""}
                if #available(iOS 12.0, *) {
                    donatePaste(verse: "search \(filteredBooks[0]) chapter \(filteredChapters[0]) verse \(filteredVerses[number])")
                }
                searchBibleDelegate?.requestToOpenBibleVerse(book: filteredBooks[0], chapter: filteredChapters[0], verse: filteredVerses[number])
                return ""
            }
        } else {
            let verse = searchedVerses[index]
            searchBibleDelegate?.requestToOpenBibleVerse(book: verse.book, chapter: verse.chapter, verse: verse.verse)
            return ""
        }
        
    }
    
    func searchPressed(for text: String) -> [Any] {
        if searchState == .verse {
            switch searchParameter {
            case .empty:
                return []
            case .book:
                guard let book = filteredBooks.first else {return []}
                searchBibleDelegate?.requestToOpenBibleVerse(book: book, chapter: 1, verse: 1)
                return [book]
            case .chapter:
                guard let book = filteredBooks.first else {return []}
                guard let chapter = filteredChapters.first else { return [filteredBooks[0]]}
                searchBibleDelegate?.requestToOpenBibleVerse(book: book, chapter: chapter, verse: 1)
                return [book, chapter]
            case .verse:
                guard let book = filteredBooks.first else {return []}
                guard let chapter = filteredChapters.first else { return [filteredBooks[0]]}
                guard let verse = filteredVerses.first else { return [filteredBooks[0], filteredChapters[0]] }
                searchBibleDelegate?.requestToOpenBibleVerse(book: book, chapter: chapter, verse: verse)
                if #available(iOS 12.0, *) {
                    //                donate(book: book, chapter: chapter, verse: verse)
                    donatePaste(verse: "search \(book) chapter \(chapter) verse \(verse)")
                }
                return [book, chapter, verse]
            }
        } else {
            fetchOffset = 0
            searchedVerses = verseDataManager.searchForWord(searchWord: text, fetchOffset: fetchOffset)
            searchWordDelegate?.didFinishSearching()
            return []
        }
        
        
    }
    
    func getHeaderLabel() -> String {
        if searchState == .verse {
            switch searchParameter {
            case .empty:
                return "Books"
            case .book:
                return "Books"
            case .chapter:
                return "Chapters"
            case .verse:
                return "Verses"
            }
        } else {
            return "Verses"
        }
    }
    
    var requestingMoreVerses = false
    
    func observeTableViewToLoadMoreVerses(for index: Int, text: String) {
        if (index > (searchedVerses.count - 10)) && (searchedVerses.count%50 == 0) && searchedVerses.count != 0 {
            if !requestingMoreVerses {
                requestingMoreVerses.toggle()
                fetchOffset += 50
                let newVerses = verseDataManager.searchForWord(searchWord: text, fetchOffset: fetchOffset)
                let newFirstRow = searchedVerses.count
                searchedVerses += newVerses
                let indexPathArray = Array(newFirstRow...(searchedVerses.count - 1)).map({IndexPath(row: $0, section: 0)})
                requestingMoreVerses.toggle()
                searchWordDelegate?.didFinishLoadingMoreVerses(for: indexPathArray)
            }
        }
        
    }
    
    
    @available(iOS 12.0, *)
    func donatePaste(verse: String) {
        UIPasteboard.general.string = verse

        let intent = SearchBibleIntentIntent()

        let interaction = INInteraction(intent: intent, response: nil)

        // 4
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Interaction donation failed: \(error.description)")
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
    }
}

protocol SearchBibleDelegate: class {
    func requestToOpenBibleVerse(book: String, chapter: Int, verse: Int)
}

protocol SearchWordDelegate: class {
    func didFinishSearching()
    func didFinishLoadingMoreVerses(for indexPaths: [IndexPath])
}

