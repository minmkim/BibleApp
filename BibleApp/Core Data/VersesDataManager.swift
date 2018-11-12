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
    
    let persistentContainer: NSPersistentContainer!
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func loadVerses(completion: ([SavedVerse]) -> Void) {
        
        let managedContext = persistentContainer.viewContext
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
        let managedContext = persistentContainer.viewContext
        
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
        newVerse.setValue(bibleVerse.version, forKey: CoreDataVerse.version)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveNewSection(for section: String) {
        
        let managedContext = persistentContainer.viewContext
        
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
        
        let managedContext = persistentContainer.viewContext
        
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
    
    func deleteVerse(for bibleVerse: SavedVerse) {
        let managedContext = persistentContainer.viewContext
        let verseFetch = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataVerse.entity)
        let p1 = NSPredicate(format: "book = %@", bibleVerse.book)
        let p2 = NSPredicate(format: "chapter = %d", bibleVerse.chapter)
        let p3 = NSPredicate(format: "verse = %d", bibleVerse.verse)
        let p4 = NSPredicate(format: "version = %@", bibleVerse.version)
        if let sectionName = bibleVerse.sectionName {
            let p5 = NSPredicate(format: "sectionName = %@", sectionName)
            let p6 = NSPredicate(format: "noteName = %@", bibleVerse.noteName!)
            verseFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3, p4, p5, p6])
        } else {
            verseFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3, p4])
        }
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
    
    func deleteSection(_ section: String) {
        let managedContext = persistentContainer.viewContext
        let sectionFetch = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataSection.entity)
        let p1 = NSPredicate(format: "sectionName = %@", section)
        sectionFetch.predicate = p1
        
        let sections = try! managedContext.fetch(sectionFetch)
        for section in sections {
            managedContext.delete(section as! NSManagedObject)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("error")
        }
    }
    
    func deleteNote(note: String, section: String) {
        let managedContext = persistentContainer.viewContext
        let noteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataNote.entity)
        let p1 = NSPredicate(format: "section.sectionName = %@", section)
        let p2 = NSPredicate(format: "noteName = %@", note)
        noteFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        
        let notes = try! managedContext.fetch(noteFetch)
        for note in notes {
            managedContext.delete(note as! NSManagedObject)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("error")
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataVerse.entity)
        let newP1 = NSPredicate(format: "sectionName = %@", section)
        let newP2 = NSPredicate(format: "noteName = %@", note)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newP1, newP2])
        do {
            let fetchedVerses = try managedContext.fetch(fetchRequest)
            fetchedVerses.forEach { (verse) in
                managedContext.delete(verse)
                
                do {
                    try managedContext.save()
                } catch {
                    print("error")
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func loadBible(version: String, completion: ([BibleVerse]) -> Void) {
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataBible.entity)
        let predicate = NSPredicate(format: "version = %@", version)
        fetchRequest.predicate = predicate
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
    
    func loadBibleBook(_ book: String, forChapter chapter: Int, version: String, completion: ([BibleVerse]) -> Void) {
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataBible.entity)
        let p1 = NSPredicate(format: "version = %@", version)
        let p2 = NSPredicate(format: "book = %@", book)
        let p3 = NSPredicate(format: "chapter = %d", chapter)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3])
        var savedVerses = [BibleVerse]()
        do {
            let fetchedVerses = try managedContext.fetch(fetchRequest)
            fetchedVerses.forEach { (verse) in
                let newVerse = BibleVerse(fetchedVerse: verse)
                savedVerses.append(newVerse)
            }
            savedVerses.sort(by: {$0.verse < $1.verse})
            completion(savedVerses)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getVerseCountFor(book: String, chapter: Int, version: String, completion: (Int) -> Void) {
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataBible.entity)
        let p1 = NSPredicate(format: "version = %@", version)
        let p2 = NSPredicate(format: "book = %@", book)
        let p3 = NSPredicate(format: "chapter = %d", chapter)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3])
        do {
            let countOfVerses = try managedContext.count(for: fetchRequest)
            completion(countOfVerses)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func loadSections(completion: ([String]) -> Void) {
        let managedContext = persistentContainer.viewContext
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
        
        let managedContext = persistentContainer.viewContext
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
    
    func loadSavedVerses(for note: String, section: String, completion: ([SavedVerse]) -> Void) {
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataVerse.entity)
        let p1 = NSPredicate(format: "sectionName = %@", section)
        let p2 = NSPredicate(format: "noteName = %@", note)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
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
        
        let managedContext = persistentContainer.viewContext
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
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataVerse.entity)
        let p1 = NSPredicate(format: "noteName = nil")
        let p2 = NSPredicate(format: "chapter = %d", verse.chapter)
        let p3 = NSPredicate(format: "verse = %d", verse.verse)
        let p4 = NSPredicate(format: "book = %@", verse.book)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3, p4])
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
    
    func searchForWord(searchWord: String, version: String, fetchOffset: Int, completion: ([BibleVerse]) -> Void) {
        
        let context = persistentContainer.viewContext
        var savedVerses = [BibleVerse]()
        do {
            let managedContext = NSFetchRequest<NSManagedObject>(entityName: CoreDataBible.entity)
            let p1 = NSPredicate(format: "version = %@", version)
            let p2 = NSPredicate(format: "text CONTAINS[cd] %@", searchWord.lowercased())
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
            managedContext.predicate = predicate
            managedContext.fetchLimit = 50
            managedContext.fetchOffset = fetchOffset
            let fetchedVerses = try context.fetch(managedContext)
            fetchedVerses.forEach { (verse) in
                let newVerse = BibleVerse(fetchedVerse: verse)
                savedVerses.append(newVerse)
            }
            completion(savedVerses)
        }
        catch {
            print ("fetch task failed", error)
        }
    }
    
}
