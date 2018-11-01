//
//  Protocols.swift
//  BibleApp
//
//  Created by Min Kim on 10/27/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

protocol SearchController {
    
    func didPressSearch(for searchText: String)
    func getNumberOfRowsInSection() -> Int
    func getTextLabelForRow(for index: Int) -> String
    func getHeaderLabel() -> String
    func filterContentForSearchText(_ searchText: String)
    func didSelectItem(at index: Int)
}

extension SearchController {
    func removeBeginningWhiteSpace(_ text: String) -> String {
        var returnString = text
        while text.first == " " {
            returnString = String(text.dropFirst())
        }
        return returnString
    }
}

protocol SearchVerseDelegate: class {
    func requestToOpenBibleVerse(book: String, chapter: Int, verse: Int)
}

protocol SearchWordDelegate: class {
    func didFinishSearching()
    func didFinishLoadingMoreVerses(for indexPaths: [IndexPath])
}

protocol UpdateSearchBarDelegate: class {
    func updateSearchBar(_ text: String)
}

protocol IndexVerseDelegate: class {
    func moveToVerse(multiplier: Double)
}

protocol SavedVerseDelegate: class {
    func requestToOpenVerse(for verse: SavedVerse)
}

protocol CreateNewNoteDelegate: class {
    func newNote(for text: String, section: String)
}

protocol DidSelectNoteDelegate: class {
    func selectedNoteSection(note: String, section: String)
}

protocol BibleVerseDelegate: class {
    func openBibleVerse(book: String, chapter: Int, verse: Int)
}
