//
//  Delegates.swift
//  BibleApp
//
//  Created by Min Kim on 11/4/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

protocol SearchVerseDelegate: class {
    func requestToOpenBibleVerse(book: String, chapter: Int, verse: Int)
}

protocol SearchWordDelegate: class {
    func didFinishSearching()
    func didFinishLoadingMoreVerses(for indexPaths: [IndexPath])
}

protocol UpdateSearchBarDelegate: class {
    func updateSearchBar(_ text: String)
}

protocol IndexVerseDelegate: class {
    func moveToVerse(multiplier: Double)
}

protocol SavedVerseDelegate: class {
    func requestToOpenVerse(for verse: SavedVerse)
}

protocol CreateNewNoteDelegate: class {
    func newNote(for text: String, section: String)
}

protocol DidSelectNoteDelegate: class {
    func selectedNoteSection(note: String, section: String)
}

protocol BibleVerseDelegate: class {
    func openBibleVerse(book: String, chapter: Int, verse: Int)
}

protocol DidPressNoteDelegate: class {
    func didPressNote(at indexPath: IndexPath, row: Int, note: String)
}

protocol DidDragVerseDelegate: class {
    func didDragVerse(for verse: SavedVerse, note: String, row: Int)
}

protocol ChapterPressDelegate: class {
    func didPressPreviousChapter()
    func didPressNextChapter()
    func didPressChapterLabel(for chapter: Int)
}

protocol DidSelectChapterLabelViewDelegate: class {
    func didSelectChapter(at chapter: Int)
}

protocol SaveVerseBarDelegate: class {
    func didPressTrash()
    func didPressAdd()
}

protocol SavedVerseActionBarDelegate: class {
    func didPressTrash()
    func didPressShare()
}

protocol IndexListDelegate: class {
    func pressedIndex(at index: Int)
}

protocol DidSelectChapterCVDelegate: class {
    func didSelectChapter(for chapter: Int)
}

protocol SavedVerseHeaderDelegate: class {
    func didPressAddNote(at row: Int)
    func didPressCancel()
}

protocol DidSelectSavedVersesDelegate: class {
    func didPress(forVerse savedVerse: SavedVerse, forIndexPath: IndexPath)
}

protocol TabSelectedDelegate: class {
    func didSelectTab(at index: Int)
}

protocol BibleCoordinatorDelegate: class {
    func openBibleWebsite(for indexPath: IndexPath)
    func openBibleChapter(book: String, chapter: Int)
}

protocol ChangeChapterDelegate: class {
    func previousChapter()
    func nextChapter()
    func goToChapter(_ chapter: Int)
    func closeController()
}

protocol SaveVerseDelegate: class {
    func presentSaveVerses()
}

protocol OpenNoteDelegate: class {
    func didPressNote(forNote note: String, index: Int)
}

protocol OpenVerseDelegate: class {
    func didPressVerse()
}

protocol ChangeSearchControllerDelegate: class {
    func didChangeSearch(for index: Int)
}
