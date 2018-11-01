//
//  SavedVerseView + DidAddNote.swift
//  BibleApp
//
//  Created by Min Kim on 10/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

extension SavedVerseViewController: SavedVerseHeaderDelegate {
    func didPressCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func didPressAddNote(at row: Int) {
        if !isEditingSections {
            addNewNote(for: row+1)
        }
    }
}
