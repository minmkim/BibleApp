//
//  CoreDataEnum.swift
//  BibleApp
//
//  Created by Min Kim on 8/23/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

enum CoreDataVerse {
    static let entity = "CDBibleVerse"
    static let book = "book"
    static let chapter = "chapter"
    static let verse = "verse"
    static let text = "text"
    static let isMultipleVerses = "isMultipleVerses"
    static let upToVerse = "upToVerse"
    static let noteName = "noteName"
    static let sectionName = "sectionName"
    static let version = "version"
}

enum CoreDataBible {
    static let entity = "CDBible"
    static let book = "book"
    static let chapter = "chapter"
    static let verse = "verse"
    static let text = "text"
    static let version = "version"
    static let isHighlighted = "isHighlighted"
}

enum CoreDataSection {
    static let entity = "Section"
    static let sectionName = "sectionName"
}

enum CoreDataNote {
    static let entity = "Note"
    static let noteName = "noteName"
}

enum BibleVersions {
    static let niv1984 = "NIV1984"
    static let KRV = "KRV"
}

