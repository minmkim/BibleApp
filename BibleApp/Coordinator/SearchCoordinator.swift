//
//  SearchCoordinator.swift
//  BibleApp
//
//  Created by Min Kim on 9/15/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

final class SearchCoordinator: Coordinator {
    
    weak var bibleVerseDelegate: BibleVerseDelegate?
    var searchViewController: SearchViewController!
    var bible: Bible!

    init(searchViewController: SearchViewController, bible: Bible) {
        self.searchViewController = searchViewController
        self.bible = bible
        self.searchViewController.changeSearchControllerDelegate = self
        if let controller = searchViewController.searchControllers as? VerseSearchController {
            controller.searchVerseDelegate = self
            controller.updateSearchBarDelegate = searchViewController
        }
        
        if let controller = searchViewController.searchControllers as? WordSearchController {
            controller.searchWordDelegate = searchViewController
            controller.searchVerseDelegate = self
        }
        
        print("init search")
    }
    
    deinit {
        print("deinit search")
    }
    
}

extension SearchCoordinator: ChangeSearchControllerDelegate {
    func didChangeSearch(for index: Int) {
        if index == 0 {
            let controller = VerseSearchController(bible: bible)
            searchViewController.searchControllers = controller
            controller.searchVerseDelegate = self
            controller.updateSearchBarDelegate = searchViewController
        } else {
            let controller = WordSearchController(bible: bible)
            searchViewController.searchControllers = controller
            controller.searchWordDelegate = searchViewController
            controller.searchVerseDelegate = self
        }
    }
    
}

extension SearchCoordinator: SearchVerseDelegate {
    func requestToOpenBibleVerse(book: String, chapter: Int, verse: Int) {
        bibleVerseDelegate?.openBibleVerse(book: book, chapter: chapter, verse: verse)
    }
    
}


