//
//  SavedVerses.swift
//  BibleApp
//
//  Created by Min Kim on 10/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

final class SavedVersesController {
    typealias Section = String
    typealias Note = String
    
    private var sectionLabels = [Section]()
    private var notesLabels = [Section : [Note]]()
    private var dataManager: VersesDataManager!
    
    init(dataManager: VersesDataManager) {
        self.dataManager = dataManager
        loadSectionsAndNotes()
    }
    
    func loadSectionsAndNotes() {
        dataManager.loadSections { (sections) in
            sectionLabels = sections
        }
        sectionLabels = Array(Set(sectionLabels)).sorted()
        sectionLabels.forEach { (header) in
            dataManager.loadNotes(for: header) { (fetchedNotes) in
                notesLabels[header] = Array(Set(fetchedNotes)).sorted(by: >)
            }
        }
    }
    
    func saveVerse(for verse: SavedVerse) {
        dataManager.saveToCoreData(bibleVerse: verse)
    }
    
    func getNotes(for index: Int) -> [String] {
        let section = sectionLabels[index]
        return notesLabels[section] ?? []
    }
    
    func getSection(for index: Int) -> String {
        return sectionLabels[index]
    }
    
    func getNumberOfSections() -> Int {
        return sectionLabels.count
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
        sectionLabels.append(section)
        notesLabels[section] = []
    }
    
    func saveNewNote(newNote: String, index: Int) {
        let section = sectionLabels[index]
        var array = notesLabels[section] ?? []
        array.append(newNote)
        notesLabels[section] = array
        dataManager.saveNewNote(for: newNote, section: section)
    }
    
    func saveNewNoteWithSection(newNote: String, section: String) {
        var array = notesLabels[section] ?? []
        array.append(newNote)
        notesLabels[section] = array
        dataManager.saveNewNote(for: newNote, section: section)
    }
    
    func updateVerseToNote(verse: SavedVerse, note: String, section: String) {
        DispatchQueue.main.async { [weak self] in
            self?.dataManager.updateVerseAfterDrag(verse: verse, newSection: section, newNote: note)
        }
        
    }
    
    func deleteVerse(_ verse: SavedVerse) {
        dataManager.deleteVerse(for: verse)
    }
    
    func removeNote(note: String, section: String) {
        guard var notesInSection = notesLabels[section] else {return}
        notesInSection = notesInSection.filter({$0 != note})
        notesLabels[section] = (notesInSection.count == 0) ? nil : notesInSection
        dataManager.deleteNote(note: note, section: section)
    }
    
    func removeSection(for section: String) {
        if let notesInSection = notesLabels[section] {
            notesInSection.forEach { dataManager.deleteNote(note: $0, section: section) }
            notesLabels[section] = nil
        }
        sectionLabels = sectionLabels.filter({$0 != section})
        dataManager.deleteSection(section)
    }
    
    
}
