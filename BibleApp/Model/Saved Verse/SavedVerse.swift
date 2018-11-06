//
//  SavedVerse.swift
//  BibleApp
//
//  Created by Min Kim on 9/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import CoreData
import MobileCoreServices

final class SavedVerse: NSObject {
    
    var book: String
    var chapter: Int
    var verse: Int
    var text: String
    var upToVerse: Int?
    var isMultipleVerses: Bool = false
    var noteName: String?
    var sectionName: String?
    var version: String
    
    init(book: String, chapter: Int, verse: Int, text: String, upToVerse: Int? = nil, isMultipleVerses: Bool = false, noteName: String? = nil, sectionName: String? = nil, version: String) {
        self.book = book
        self.chapter = chapter
        self.verse = verse
        self.text = text
        self.isMultipleVerses = isMultipleVerses
        self.noteName = noteName
        self.sectionName = sectionName
        self.version = version
    }
    
    init?(bibleVerses: [BibleVerse], noteName: String? = nil, sectionName: String? = nil) {
        let sortedVerses = bibleVerses.sorted(by: {$0.verse < $1.verse})
        switch sortedVerses.count {
        case 0:
            return nil
        case 1:
            guard let firstVerse = sortedVerses.first else {return nil}
            self.book = firstVerse.book
            self.chapter = firstVerse.chapter
            self.verse = firstVerse.verse
            self.text = firstVerse.text
            self.isMultipleVerses = false
            self.version = firstVerse.version
        case let x where x > 1:
            let firstVerse = sortedVerses.first!
            self.book = firstVerse.book
            self.chapter = firstVerse.chapter
            self.verse = firstVerse.verse
            self.version = firstVerse.version
            isMultipleVerses = true
            let lastVerse = sortedVerses.last!
            self.upToVerse = lastVerse.verse
            var text = ""
            sortedVerses.forEach { (verse) in
                text += "\n\(verse.verse) \(verse.text)"
            }
            text.removeFirst()
            self.text = text
        default:
            return nil
        }
        self.noteName = noteName
        self.sectionName = sectionName
    }
    
    init(fetchedVerse: NSManagedObject) {
        self.book = fetchedVerse.value(forKey: CoreDataVerse.book) as! String
        self.chapter = fetchedVerse.value(forKey: CoreDataVerse.chapter) as! Int
        self.verse = fetchedVerse.value(forKey: CoreDataVerse.verse) as! Int
        self.text = fetchedVerse.value(forKey: CoreDataVerse.text) as! String
        self.upToVerse = fetchedVerse.value(forKey: CoreDataVerse.upToVerse) as? Int
        self.isMultipleVerses = (fetchedVerse.value(forKey: CoreDataVerse.isMultipleVerses) as? Bool) ?? false
        self.noteName = fetchedVerse.value(forKey: CoreDataVerse.noteName) as? String
        self.sectionName = fetchedVerse.value(forKey: CoreDataVerse.sectionName) as? String
        self.version = fetchedVerse.value(forKey: CoreDataVerse.version) as! String
    }
    
    func formattedVerse() -> String {
        return isMultipleVerses ? "\(book) \(chapter):\(verse)-\(upToVerse ?? 0) (\(version))" : "\(book) \(chapter):\(verse) (\(version))"
    }
    
    func formattedVerseAndText() -> String {
        return isMultipleVerses ? "\(text)\n\(book) \(chapter):\(verse)-\(upToVerse ?? 0) (\(version))" : "\(text)\n\(book) \(chapter):\(verse) (\(version))"
    }
    
    
    
}

//allow SavedVerse to be object in drag and drop
extension SavedVerse: NSItemProviderReading, NSItemProviderWriting, Codable {
    
    static var readableTypeIdentifiersForItemProvider: [String] {return [(kUTTypeData as String)]}
    static var writableTypeIdentifiersForItemProvider: [String] {return [(kUTTypeData as String)]}
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> SavedVerse {
        let decoder = JSONDecoder()
        do {
            let savedVerse = try decoder.decode(SavedVerse.self, from: data)
            return savedVerse
        } catch {
            fatalError("error decoding")
        }
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        do {
            let data = try JSONEncoder().encode(self)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        return progress
    }
    
}
