//
//  SearchCoordinator.swift
//  BibleApp
//
//  Created by Min Kim on 9/15/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

class SearchCoordinator: Coordinator {
    
    weak var bibleVerseDelegate: BibleVerseDelegate?
    let searchViewController: SearchViewController!

    init(searchViewController: SearchViewController) {
        self.searchViewController = searchViewController
        searchViewController.searchViewModel.searchBibleDelegate = self
        print("init search")
    }
    
    deinit {
        print("deinit search")
    }
    
}

extension SearchCoordinator: SearchBibleDelegate {
    func requestToOpenBibleVerse(book: String, chapter: Int, verse: Int) {
        bibleVerseDelegate?.openBibleVerse(book: book, chapter: chapter, verse: verse)
    }
    
}


