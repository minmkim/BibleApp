//
//  WordSearchController.swift
//  BibleApp
//
//  Created by Min Kim on 10/26/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

final class WordSearchController: SearchController {
    
    weak var searchWordDelegate: SearchWordDelegate?
    weak var searchVerseDelegate: SearchVerseDelegate?
    var bible: Bible!
    var searchedVerses = [BibleVerse]()
    var requestingMoreVerses = false
    var fetchOffset = 0
    
    init(bible: Bible) {
        self.bible = bible
    }
    deinit {
        print("deinit wordsearch")
    }
    
    func didPressSearch(for searchText: String) {
        fetchOffset = 0
        
        bible.searchBibleForWords(removeBeginningWhiteSpace(searchText), withOffset: fetchOffset) { (fetchedVerses) in
            searchedVerses = fetchedVerses
            searchWordDelegate?.didFinishSearching()
        }
    }
    
    func observeTableViewToLoadMoreVerses(for index: Int, searchText: String) {
        if (index > (searchedVerses.count - 10)) && (searchedVerses.count%50 == 0) && searchedVerses.count != 0 {
            if !requestingMoreVerses {
                requestingMoreVerses.toggle()
                fetchOffset += 50
                bible.searchBibleForWords(removeBeginningWhiteSpace(searchText), withOffset: fetchOffset) { (fetchedVerses) in
                    let newFirstRow = searchedVerses.count
                    searchedVerses += fetchedVerses
                    let indexPathArray = Array(newFirstRow...(searchedVerses.count - 1)).map({IndexPath(row: $0, section: 0)})
                    requestingMoreVerses.toggle()
                    searchWordDelegate?.didFinishLoadingMoreVerses(for: indexPathArray)
                }
            }
        }
    }
    
    func getNumberOfRowsInSection() -> Int {
        return searchedVerses.count
    }
    
    func getTextLabelForRow(for index: Int) -> String {
        return searchedVerses[index].formattedVerse()
    }
    
    func getHeaderLabel() -> String {
        return "Verses"
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            searchedVerses.removeAll()
            searchWordDelegate?.didFinishSearching()
        }
    }
    
    func didSelectItem(at index: Int) {
        let verse = searchedVerses[index]
        searchVerseDelegate?.requestToOpenBibleVerse(book: verse.book, chapter: verse.chapter, verse: verse.verse, version: verse.version)
    }
}
