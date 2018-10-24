//
//  VersesDataManager.swift
//  BibleApp
//
//  Created by Min Kim on 8/24/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class VersesDataManager {
    
    init() {
        print("data")
    }
    
    deinit {
        print("no data")
    }
    
    func loadVerses(completion: ([SavedVerse]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataVerse.entity)
        var savedVerses = [SavedVerse]()
        do {
            let fetchedVerses = try managedContext.fetch(fetchRequest)
            fetchedVerses.forEach { (verse) in
                let newVerse = SavedVerse(fetchedVerse: verse)
                savedVerses.append(newVerse)
            }
            completion(savedVerses)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveToCoreData(bibleVerse: SavedVerse) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if !isDuplicateVerse(for: bibleVerse) {
            let entity = NSEntityDescription.entity(forEntityName: CoreDataVerse.entity, in: managedContext)!
            
            let newVerse = NSManagedObject(entity: entity, insertInto: managedContext)
            newVerse.setValue(bibleVerse.book, forKeyPath: CoreDataVerse.book)
            newVerse.setValue(bibleVerse.chapter, forKeyPath: CoreDataVerse.chapter)
            newVerse.setValue(bibleVerse.verse, forKeyPath: CoreDataVerse.verse)
            newVerse.setValue(bibleVerse.text, forKeyPath: CoreDataVerse.text)
            newVerse.setValue(bibleVerse.isMultipleVerses, forKey: CoreDataVerse.isMultipleVerses)
            newVerse.setValue(bibleVerse.upToVerse, forKey: CoreDataVerse.upToVerse)
            newVerse.setValue(bibleVerse.sectionName, forKey: CoreDataVerse.sectionName)
            newVerse.setValue(bibleVerse.noteName, forKey: CoreDataVerse.noteName)
            
            if let sectionName = bibleVerse.sectionName, let noteName = bibleVerse.noteName {
                let section = Section(context: managedContext)
                section.sectionName = sectionName
                let note = Note(context: managedContext)
                note.noteName = noteName
                section.addToNotes(note)
                
                let verse = CDBibleVerse(context: managedContext)
                verse.book = bibleVerse.book
                verse.chapter = Int16(bibleVerse.chapter)
                verse.verse = Int16(bibleVerse.verse)
                verse.text = bibleVerse.text
                verse.isMultipleVerses = bibleVerse.isMultipleVerses
                verse.sectionName = bibleVerse.sectionName
                verse.noteName = bibleVerse.noteName
                note.addToVerses(verse)
            }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveNewSection(for section: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: CoreDataSection.entity, in: managedContext)!
        
        let newSection = NSManagedObject(entity: entity, insertInto: managedContext)
        newSection.setValue(section, forKeyPath: CoreDataSection.sectionName)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveNewNote(for note: String, section: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: CoreDataNote.entity, in: managedContext)!
        
        let newNote = NSManagedObject(entity: entity, insertInto: managedContext)
        newNote.setValue(note, forKeyPath: CoreDataNote.noteName)
        let managedSection = Section(context: managedContext)
        managedSection.sectionName = section
        let managedNote = Note(context: managedContext)
        managedNote.noteName = note
        managedSection.addToNotes(managedNote)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func isDuplicateVerse(for bibleVerse: SavedVerse) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return true }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let verseFetch = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataVerse.entity)
        verseFetch.fetchLimit = 1
        let p1 = NSPredicate(format: "book = %@", bibleVerse.book)
        let p2 = NSPredicate(format: "chapter = %d", bibleVerse.chapter)
        let p3 = NSPredicate(format: "verse = %d", bibleVerse.verse)
        verseFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3])
        let verses = try! managedContext.fetch(verseFetch)
        return verses.count == 0 ? false : true
    }
    
    func deleteVerse(for bibleVerse: SavedVerse) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let verseFetch = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataVerse.entity)
        let p1 = NSPredicate(format: "book = %@", bibleVerse.book)
        let p2 = NSPredicate(format: "chapter = %d", bibleVerse.chapter)
        let p3 = NSPredicate(format: "verse = %d", bibleVerse.verse)
        verseFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3])
        
        let verses = try! managedContext.fetch(verseFetch)
        for verse in verses {
            managedContext.delete(verse as! NSManagedObject)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("error")
        }
    }
    
    func loadBible(completion: ([BibleVerse]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataBible.entity)
        var savedVerses = [BibleVerse]()
        do {
            let fetchedVerses = try managedContext.fetch(fetchRequest)
            fetchedVerses.forEach { (verse) in
                let newVerse = BibleVerse(fetchedVerse: verse)
                savedVerses.append(newVerse)
            }
            completion(savedVerses)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func loadSections(completion: ([String]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataSection.entity)
        var sections = [String]()
        do {
            let fetchedSections = try managedContext.fetch(fetchRequest)
            fetchedSections.forEach { (section) in
                
                let sectionString = section.value(forKey: CoreDataSection.sectionName) as! String
                sections.append(sectionString)
            }
            completion(sections)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func loadNotes(for section: String, completion: ([String]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataNote.entity)
        let predicate = NSPredicate(format:"ANY section.sectionName == %@", section)
        fetchRequest.predicate = predicate
        var sections = [String]()
        do {
            let fetchedSections = try managedContext.fetch(fetchRequest)
            fetchedSections.forEach { (section) in
                let sectionString = section.value(forKey: CoreDataNote.noteName) as! String
                sections.append(sectionString)
            }
            completion(sections)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func loadSavedVerses(for note: String, completion: ([SavedVerse]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataVerse.entity)
        let predicate = NSPredicate(format:"ANY note.noteName == %@", note)
        fetchRequest.predicate = predicate
        
        var savedVerses = [SavedVerse]()
        do {
            let fetchedVerses = try managedContext.fetch(fetchRequest)
            fetchedVerses.forEach { (verse) in
                let newVerse = SavedVerse(fetchedVerse: verse)
                savedVerses.append(newVerse)
            }
            completion(savedVerses)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func loadSavedVersesWithoutSection(completion: ([SavedVerse]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataVerse.entity)
        let predicate = NSPredicate(format: "noteName = nil")
        fetchRequest.predicate = predicate
        
        var savedVerses = [SavedVerse]()
        do {
            let fetchedVerses = try managedContext.fetch(fetchRequest)
            fetchedVerses.forEach { (verse) in
                let newVerse = SavedVerse(fetchedVerse: verse)
                savedVerses.append(newVerse)
            }
            completion(savedVerses)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func updateVerseAfterDrag(verse: SavedVerse, newSection: String, newNote: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataVerse.entity)
        let p1 = NSPredicate(format: "noteName = nil")
        let p2 = NSPredicate(format: "text = %@", verse.text)
//        let p3 = NSPredicate(format: "chapter = %@", verse.chapter)
//        let p4 = NSPredicate(format: "verse = %@", verse.verse)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        fetchRequest.predicate = predicate
        
        var savedVerses = [NSManagedObject]()
        do {
            let fetchedVerses = try managedContext.fetch(fetchRequest)
            fetchedVerses.forEach { (verse) in
                savedVerses.append(verse)
            }
            if let fetchedVerse = savedVerses.first {
                fetchedVerse.setValue(newSection, forKey: CoreDataVerse.sectionName)
                fetchedVerse.setValue(newNote, forKey: CoreDataVerse.noteName)
                let relVerse = CDBibleVerse(context: managedContext)
                let relNote = Note(context: managedContext)
                relNote.noteName = newNote
                relVerse.book = verse.book
                relVerse.chapter = Int16(verse.chapter)
                relVerse.verse = Int16(verse.verse)
                relVerse.text = verse.text
                relVerse.isMultipleVerses = verse.isMultipleVerses
                relVerse.sectionName = newSection
                relVerse.noteName = newNote
                relNote.addToVerses(relVerse)
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func searchForWord(searchWord: String, fetchOffset: Int) -> [BibleVerse] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        let context = appDelegate.persistentContainer.viewContext
        var savedVerses = [BibleVerse]()
        do {
            let managedContext = NSFetchRequest<NSManagedObject>(entityName: CoreDataBible.entity)
            managedContext.predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchWord.lowercased())
            managedContext.fetchLimit = 50
            managedContext.fetchOffset = fetchOffset
            let fetchedVerses = try context.fetch(managedContext)
            fetchedVerses.forEach { (verse) in
                let newVerse = BibleVerse(fetchedVerse: verse)
                savedVerses.append(newVerse)
            }
            return savedVerses
        }
        catch {
            print ("fetch task failed", error)
            return []
        }
    }
    
    func preloadDBData() {
        let sqlitePath = Bundle.main.path(forResource: "MtZion", ofType: "sqlite")
        let sqlitePath_shm = Bundle.main.path(forResource: "MtZion", ofType: "sqlite-shm")
        let sqlitePath_wal = Bundle.main.path(forResource: "MtZion", ofType: "sqlite-wal")
        
        let URL1 = URL(fileURLWithPath: sqlitePath!)
        let URL2 = URL(fileURLWithPath: sqlitePath_shm!)
        let URL3 = URL(fileURLWithPath: sqlitePath_wal!)
        let URL4 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MtZion.sqlite")
        let URL5 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MtZion.sqlite-shm")
        let URL6 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MtZion.sqlite-wal")
        
        if !FileManager.default.fileExists(atPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MtZion.sqlite") {
            // Copy 3 files
            do {
                try FileManager.default.copyItem(at: URL1, to: URL4)
                try FileManager.default.copyItem(at: URL2, to: URL5)
                try FileManager.default.copyItem(at: URL3, to: URL6)
                
                print("=======================")
                print("FILES COPIED")
                print("=======================")
                
            } catch {
                print("=======================")
                print("ERROR IN COPY OPERATION")
                print("=======================")
            }
        } else {
            print("=======================")
            print("FILES EXIST")
            print("=======================")
        }
    }
    
}
