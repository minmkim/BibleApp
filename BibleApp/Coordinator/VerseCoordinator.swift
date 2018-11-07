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
    var savedVersesModel: SavedVersesController
    var currentVerseViewController: VerseViewController?
    
    
    deinit {
        print("deinit verse")
    }
    
    init(savedVerseController: SavedVerseViewController, savedVersesModel: SavedVersesController) {
        self.savedVerseController = savedVerseController
        self.savedVersesModel = savedVersesModel
        savedVerseController.savedVerseDelegate = self
        savedVerseController.openNoteDelegate = self
    }
    
}

extension VerseCoordinator: SavedVerseDelegate {
    func requestToOpenVerse(for verse: SavedVerse) {
        bibleVerseDelegate?.openBibleVerse(book: verse.book, chapter: verse.chapter, verse: verse.verse, version: verse.version)
    }
    
    
}

extension VerseCoordinator: OpenNoteDelegate {
    func didPressNote(forNote note: String, index: Int) {
        let controller = VerseViewController()
        currentVerseViewController = controller
        controller.savedVersesModel = savedVersesModel
        controller.navigationItem.title = note
        controller.savedVerseDelegate = self
        let section = savedVersesModel.getSection(for: index)
        controller.section = section
        savedVerseController.navigationController?.pushViewController(controller, animated: true)
    }    
}


