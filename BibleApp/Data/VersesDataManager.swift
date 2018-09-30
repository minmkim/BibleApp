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
    
    func loadVerses() -> [BibleVerse] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataVerse.entity)
        var savedVerses = [BibleVerse]()
        do {
            let fetchedVerses = try managedContext.fetch(fetchRequest)
            fetchedVerses.forEach { (verse) in
                let newVerse = BibleVerse(fetchedVerse: verse)
                savedVerses.append(newVerse)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return savedVerses
    }
    
    func saveToCoreData(bibleVerse: BibleVerse) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if !isDuplicateVerse(for: bibleVerse) {
            let entity = NSEntityDescription.entity(forEntityName: CoreDataVerse.entity, in: managedContext)!
            
            let newVerse = NSManagedObject(entity: entity, insertInto: managedContext)
            newVerse.setValue(bibleVerse.book, forKeyPath: CoreDataVerse.book)
            newVerse.setValue(bibleVerse.chapter, forKeyPath: CoreDataVerse.chapter)
            newVerse.setValue(bibleVerse.verse, forKeyPath: CoreDataVerse.verse)
            newVerse.setValue(bibleVerse.text, forKeyPath: CoreDataVerse.text)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func isDuplicateVerse(for bibleVerse: BibleVerse) -> Bool {
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
    
    func deleteVerse(for bibleVerse: BibleVerse) {
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
    
    func loadBible() -> [BibleVerse] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataBible.entity)
        var savedVerses = [BibleVerse]()
        do {
            let fetchedVerses = try managedContext.fetch(fetchRequest)
            fetchedVerses.forEach { (verse) in
                let newVerse = BibleVerse(fetchedVerse: verse)
                savedVerses.append(newVerse)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return savedVerses
    }
    
    func searchForWord(searchWord: String) -> [BibleVerse] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        let context = appDelegate.persistentContainer.viewContext
        var savedVerses = [BibleVerse]()
        do {
            let managedContext = NSFetchRequest<NSManagedObject>(entityName: CoreDataBible.entity)
            managedContext.predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchWord.lowercased())
            managedContext.fetchLimit = 50
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
