//
//  iCloudVerses.swift
//  BibleApp
//
//  Created by Min Kim on 8/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import CloudKit

class iCloudVerses {
    
    let database = CKContainer.default().privateCloudDatabase
    var savedVerses = [BibleVerse]()
    
    func loadVerses(completion: @escaping () -> Void) {
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "Verse", predicate: pred)
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["book", "chapter", "verse", "text"]
        operation.resultsLimit = 50
        
        var newVerse = [BibleVerse]()
        
        operation.recordFetchedBlock = { record in
            let book = record["book"] as? String
            let chapter = record["chapter"] as? Int
            let verse = record["verse"] as? Int
            let text = record["text"] as? String
            
            let bibleVerse = BibleVerse(book: book!, chapter: chapter!, verse: verse!, text: text!)
            newVerse.append(bibleVerse)
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.savedVerses = newVerse
                    completion()
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
        }
        database.add(operation)
    }
    
}
