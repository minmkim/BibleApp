//
//  SavedVerseView + DidAddNote.swift
//  BibleApp
//
//  Created by Min Kim on 10/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

extension SavedVerseViewController: DidPressAddNoteDelegate {
    func didPressAddNote(at row: Int) {
        addNewNote(for: row+1)
    }
}
