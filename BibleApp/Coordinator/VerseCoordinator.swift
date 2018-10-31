//
//  VerseCoordinator.swift
//  BibleApp
//
//  Created by Min Kim on 9/15/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

final class VerseCoordinator: Coordinator {
    
    weak var bibleVerseDelegate: BibleVerseDelegate?
    let savedVerseController: SavedVerseViewController
    
    
    deinit {
        print("deinit verse")
    }
    
    init(savedVerseController: SavedVerseViewController) {
        self.savedVerseController = savedVerseController
    }
    
}


//need to include this into new controller
extension VerseCoordinator: SavedVerseDelegate {
    func requestToOpenVerse(for verse: SavedVerse) {
        bibleVerseDelegate?.openBibleVerse(book: verse.book, chapter: verse.chapter, verse: verse.verse)
    }
    
    
}

protocol BibleVerseDelegate: class {
    func openBibleVerse(book: String, chapter: Int, verse: Int)
}
