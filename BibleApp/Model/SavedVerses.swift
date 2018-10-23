//
//  SavedVerses.swift
//  BibleApp
//
//  Created by Min Kim on 10/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

class SavedVerses {
    
    var savedVerses = [String: [String:[SavedVerse]]]()
    var headerLabels = [String]()
    var notesLabels = [String : [String]]()
    
    init() {
        let dataManager = VersesDataManager()
        
        dataManager.loadSections { (sections) in
            headerLabels = sections
        }
        print(headerLabels)
        headerLabels = Array(Set(headerLabels)).sorted()
        headerLabels.forEach { (header) in
            dataManager.loadNotes(for: header) { (fetchedNotes) in
                notesLabels[header] = Array(Set(fetchedNotes)).sorted()
            }
        }
        
        
        dataManager.loadVerses(completion: { [weak self] (verses) in
            verses.forEach({ (savedVerse) in
                
                if let section = savedVerse.sectionName {
                    if self?.savedVerses[section] == nil {
                        self?.savedVerses[section] = [savedVerse.noteName! : [savedVerse]]
                    } else {
                        var dict = self?.savedVerses[section]!
                        if var array = dict?[savedVerse.noteName!] {
                            array.append(savedVerse)
                            dict?[savedVerse.noteName!] = array
                            self?.savedVerses[section] = dict
                        } else {
                            dict?[savedVerse.noteName!] = [savedVerse]
                            self?.savedVerses[section] = dict
                        }
                    }
                } else {
                    if var dict = self?.savedVerses["none"] {
                        var array = dict["none"]!
                        array.append(savedVerse)
                        dict["none"] = array
                        self?.savedVerses["none"] = dict
                    } else {
                        self?.savedVerses["none"] = ["none":[savedVerse]]
                    }
                }
            })
        })
    }
    
    
}
