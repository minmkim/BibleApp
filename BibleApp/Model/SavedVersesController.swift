//
//  SavedVerses.swift
//  BibleApp
//
//  Created by Min Kim on 10/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

final class SavedVersesController {
    
    private var headerLabels = [String]()
    private var notesLabels = [String : [String]]()
    var dataManager: VersesDataManager!
    
    init(dataManager: VersesDataManager) {
        self.dataManager = dataManager
        loadHeadersAndNotes()
    }
    
    func loadHeadersAndNotes() {
        dataManager.loadSections { (sections) in
            headerLabels = sections
        }
        headerLabels = Array(Set(headerLabels)).sorted()
        headerLabels.forEach { (header) in
            dataManager.loadNotes(for: header) { (fetchedNotes) in
                notesLabels[header] = Array(Set(fetchedNotes)).sorted(by: >)
            }
        }
    }
    
    func getNotes(for index: Int) -> [String] {
        let section = headerLabels[index]
        return notesLabels[section] ?? []
    }
    
    func getSection(for index: Int) -> String {
        return headerLabels[index]
    }
    
    func getNumberOfSections() -> Int {
        return headerLabels.count
    }
    
    func loadVerses(for note: String, section: String) -> [SavedVerse] {
        var savedVerses = [SavedVerse]()
        dataManager.loadSavedVerses(for: note, section: section) { (loadedVerses) in
            savedVerses = loadedVerses
        }
        return savedVerses
    }
    
    func loadVersesWithoutSection(completion: ([SavedVerse]) -> Void) {
        dataManager.loadSavedVersesWithoutSection(completion: { (loadedVerses) in
            completion(loadedVerses)
        })
    }
    
    func saveNewSection(for section: String) {
        dataManager.saveNewSection(for: section)
        headerLabels.append(section)
        notesLabels[section] = []
    }
    
    func saveNewNote(newNote: String, index: Int) {
        let section = headerLabels[index]
        var array = notesLabels[section] ?? []
        array.append(newNote)
        notesLabels[section] = array
        dataManager.saveNewNote(for: newNote, section: section)
    }
    
    func updateVerseToNote(verse: SavedVerse, note: String, section: String) {
        DispatchQueue.main.async {
            self.dataManager.updateVerseAfterDrag(verse: verse, newSection: section, newNote: note)
        }
        
    }
    
    func deleteVerse(_ verse: SavedVerse) {
        dataManager.deleteVerse(for: verse)
    }
    
    func removeNote(note: String, section: String) {
        guard var notesInSection = notesLabels[section] else {return}
        notesInSection = notesInSection.filter({$0 != note})
        if notesInSection.count == 0 {
            notesLabels[section] = nil
        } else {
            notesLabels[section] = notesInSection
        }
        dataManager.deleteNote(note: note, section: section)
    }
    
    func removeSection(for section: String) {
        if let notesInSection = notesLabels[section] {
            for note in notesInSection {
                dataManager.deleteNote(note: note, section: section)
            }
            notesLabels[section] = nil
        }
        headerLabels = headerLabels.filter({$0 != section})
        dataManager.deleteSection(section)
    }
    
    
}
