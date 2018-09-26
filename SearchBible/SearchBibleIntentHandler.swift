//
//  SearchBibleIntentHandler.swift
//  SearchBible
//
//  Created by Min Kim on 9/25/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 12.0, *)
class SearchBibleIntentHandler: NSObject, SearchBibleIntentIntentHandling {
    
    let bible = IntentBible()
    
    func handle(intent: SearchBibleIntentIntent, completion: @escaping (SearchBibleIntentIntentResponse) -> Void) {
        guard let pastedText = UIPasteboard.general.string else {return}
        let textParser = TextParser()
        let dictionaryClipboard = textParser.parseVerse(for: pastedText)
        guard let book = dictionaryClipboard["book"] else {return}
        guard let chapterString = dictionaryClipboard["chapter"] else {return}
        guard let chapter = Int(chapterString) else {return}
        guard let verseString = dictionaryClipboard["verse"] else {return}
        guard let verse = Int(verseString) else {return}
        
        bible.createBible(book: book)

        guard let bookChapterVerse = bible.bookVerseDictionary[book] else {
            return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))
        }
        
        guard let chapterVerse = bookChapterVerse[chapter] else {
            return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))
        }
        
        if chapterVerse.count > (verse - 1) {
            let text = chapterVerse[verse - 1]
            UIPasteboard.general.string = text
            return completion(SearchBibleIntentIntentResponse.success(bibleVerse: text))
        } else {
            return completion(SearchBibleIntentIntentResponse(code: .invalidVerse, userActivity: nil))
        }
        
        
    }
    
}
