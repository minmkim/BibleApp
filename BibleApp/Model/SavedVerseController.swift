//
//  SavedVerseController.swift
//  BibleApp
//
//  Created by Min Kim on 10/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

final class SavedVerseController {
    
    private let versesDataManager: VersesDataManager
    
    init(dataManager: VersesDataManager) {
        self.versesDataManager = dataManager
    }
    
    func getSavedVerses(completion: ([SavedVerse]) -> Void) {
        versesDataManager.loadVerses(completion: { (savedVerses) in
            completion(savedVerses)
        })
    }
    
    func deleteVerse(_ verse: SavedVerse) {
        versesDataManager.deleteVerse(for: verse)
    }
    
    
    
}
