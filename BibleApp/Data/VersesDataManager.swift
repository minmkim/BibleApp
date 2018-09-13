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

class VersesDataManager {
    
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
            newVerse.setValue(bibleVerse.id, forKeyPath: CoreDataVerse.id)
            
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
    
}
