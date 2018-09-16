//
//  VerseCoordinator.swift
//  BibleApp
//
//  Created by Min Kim on 9/15/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class VerseCoordinator: Coordinator {
    
    weak var bibleVerseDelegate: BibleVerseDelegate?
    let verseViewController: VerseViewController
    
    func start() {
    }
    
    deinit {
        print("deinit verse")
    }
    
    init(verseViewController: VerseViewController) {
        self.verseViewController = verseViewController
        verseViewController.savedVerseDelegate = self
        print("init verse")
    }
    
}

extension VerseCoordinator: SavedVerseDelegate {
    func requestToOpenVerse(for verse: BibleVerse) {
        bibleVerseDelegate?.openBibleVerse(book: verse.book, chapter: verse.chapter, verse: verse.verse)
    }
    

}

protocol BibleVerseDelegate: class {
    func openBibleVerse(book: String, chapter: Int, verse: Int)
}
