//
//  VerseSearchController.swift
//  BibleApp
//
//  Created by Min Kim on 10/26/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

final class VerseSearchController: SearchController {
    
    weak var updateSearchBarDelegate: UpdateSearchBarDelegate?
    weak var searchVerseDelegate: SearchVerseDelegate?
    var searchState: SearchState = .empty
    
    var bible: Bible!
    var didPressSpace = false
    var verseContainer = VerseContainer()
    
    init(bible: Bible) {
        self.bible = bible
    }
    
    deinit {
        print("deinit verse search")
    }
    
    func checkForNumberedBook(_ text: [String]) -> [String] {
        if let firstInt = Int(text[0]) {
            var returnStrings = text
            returnStrings.removeFirst()
            returnStrings[0] = "\(firstInt) " + returnStrings[0]
            return returnStrings
        } else {
            return text
        }
    }
    
    func isBookInBible(for book: String) -> Bool {
        return Constants.bookStrings.contains(book)
    }
    
    func checkIfUserPressedSpace(for text: String) {
        if removeBeginningWhiteSpace(text).last == ":" {
            didPressSpace = true
            return
        }
        didPressSpace = removeBeginningWhiteSpace(text).last == " " ? true : false
    }
    
    func filterContentForSearchText(_ searchText: String) {
        checkIfUserPressedSpace(for: searchText)
        var tokenizedSearch = searchText.tokenize()
        if tokenizedSearch.count > 1 {
            tokenizedSearch = checkForNumberedBook(tokenizedSearch)
        }
        
        for index in tokenizedSearch.indices {
            if index+1 != tokenizedSearch.count {
                setVerseContainerFromSearch(for: index+1, tokenizedSearch: tokenizedSearch, nextCount: true)
            } else {
                setVerseContainerFromSearch(for: index+1, tokenizedSearch: tokenizedSearch, nextCount: false)
            }
            
        }
    }
    
    func setVerseContainerFromSearch(for index: Int, tokenizedSearch: [String], nextCount: Bool) {
        switch index {
        case 0:
            searchState = .empty
            verseContainer.resetContainer()
        case 1:
            if isBookInBible(for: tokenizedSearch.first!) && (didPressSpace || nextCount) {
                searchState = .searchingChapter
                verseContainer.searchedBook = tokenizedSearch.first!
                verseContainer.filteredChapters = Array(1...bible.numberOfChaptersInBook(for: tokenizedSearch.first!)!)
            } else {
                searchState = .searchingBook
                verseContainer.setFilteredBooks(for: tokenizedSearch.first!)
            }
        case 2:
            if verseContainer.isChapterInBook(for: tokenizedSearch[1]) && (didPressSpace || nextCount) {
                searchState = .searchingVerse
                guard let book = verseContainer.searchedBook else {return}
                let chapterNumber = Int(tokenizedSearch[1])!
                verseContainer.searchedChapter = chapterNumber
                verseContainer.filteredVerses = Array(1...(bible.numberOfVersesInBookChapterFor(book: book, chapter: chapterNumber)!))
            } else {
                searchState = .searchingChapter
                verseContainer.setFilteredChapters(for: tokenizedSearch[1])
            }
        case 3:
            searchState = .searchingVerse
            if let verseNumber = Int(tokenizedSearch[2]) {
                verseContainer.searchedVerse = verseNumber
            }
            verseContainer.setFilteredVerses(for: tokenizedSearch[2])
        default:
            return
        }
    }
        
    func didPressSearch(for searchText: String) {
        if let book = verseContainer.searchedBook {
            searchVerseDelegate?.requestToOpenBibleVerse(book: book, chapter: verseContainer.searchedChapter ?? 1, verse: verseContainer.searchedVerse ?? 1)
            verseContainer.resetContainer()
            updateSearchBarDelegate?.updateSearchBar("")
            searchState = .empty
        }
    }
    
    func didSelectItem(at index: Int) {
        verseContainer.selectedItem(at: index, searchState: searchState)
        switch searchState {
        case .empty, .searchingBook:
            searchState = .searchingChapter
            guard let book = verseContainer.searchedBook else {return}
            updateSearchBarDelegate?.updateSearchBar("\(book) ")
        case .searchingChapter:
            searchState = .searchingVerse
            guard let book = verseContainer.searchedBook, let chapter = verseContainer.searchedChapter else {return}
            updateSearchBarDelegate?.updateSearchBar("\(book) \(chapter):")
            
        case .searchingVerse:
            if let book = verseContainer.searchedBook {
                searchVerseDelegate?.requestToOpenBibleVerse(book: book, chapter: verseContainer.searchedChapter ?? 1, verse: verseContainer.searchedVerse ?? 1)
                verseContainer.resetContainer()
                updateSearchBarDelegate?.updateSearchBar("")
                searchState = .empty
            }
        }
    }
    
    func getNumberOfRowsInSection() -> Int {
        return verseContainer.getCount(for: searchState)
    }
    
    func getTextLabelForRow(for index: Int) -> String {
        return verseContainer.getLabel(for: index, searchState: searchState)
    }
    
    func getHeaderLabel() -> String {
        return searchState.getHeaderLabel()
    }
    
}

struct VerseContainer {
    
    var filteredBooks = Constants.bookStrings
    var filteredChapters = [Int]()
    var filteredVerses = [Int]()
    var searchedBook: String?
    var searchedChapter: Int?
    var searchedVerse: Int?
    
    func getCount(for searchState: SearchState) -> Int {
        switch searchState {
        case .empty, .searchingBook:
            return filteredBooks.count
        case .searchingChapter:
            return filteredChapters.count
        case .searchingVerse:
            return filteredVerses.count
        }
    }
    
    func getLabel(for index: Int, searchState: SearchState) -> String {
        switch searchState {
        case .empty, .searchingBook:
            return filteredBooks[index]
        case .searchingChapter:
            return String(filteredChapters[index])
        case .searchingVerse:
            return String(filteredVerses[index])
        }
    }
    
    func isChapterInBook(for chapter: String) -> Bool {
        guard let chapterNumber = Int(chapter) else {return false}
        return filteredChapters.contains(chapterNumber) ? true : false
    }
    
    mutating func setFilteredBooks(for filteredBook: String) {
        filteredBooks = Constants.bookStrings.filter({ (book) -> Bool in
            return book.lowercased().contains(filteredBook.lowercased())
        })
    }
    
    mutating func setFilteredChapters(for filteredChapter: String) {
        filteredChapters = filteredChapters.filter({String($0).contains(filteredChapter)})
    }
    
    mutating func setFilteredVerses(for filteredVerse: String) {
        filteredVerses = filteredVerses.filter({String($0).contains(filteredVerse)})
    }
    
    mutating func resetContainer() {
        filteredBooks = Constants.bookStrings
        filteredChapters.removeAll()
        filteredVerses.removeAll()
        searchedBook = nil
        searchedChapter = nil
        searchedVerse = nil
    }
    
    mutating func selectedItem(at index: Int, searchState: SearchState) {
        switch searchState {
        case .empty, .searchingBook:
            searchedBook = filteredBooks[index]
        case .searchingChapter:
            searchedChapter = filteredChapters[index]
        case .searchingVerse:
            searchedVerse = filteredVerses[index]
        }
    }
}

enum SearchState {
    case empty
    case searchingBook
    case searchingChapter
    case searchingVerse
}

extension SearchState {
    func getHeaderLabel() -> String {
        switch self {
        case .empty, .searchingBook:
            return "Books"
        case .searchingChapter:
            return "Chapters"
        case .searchingVerse:
            return "Verses"
        }
    }
}
