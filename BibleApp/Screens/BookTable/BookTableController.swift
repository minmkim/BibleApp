//
//  BookTableController.swift
//  BibleApp
//
//  Created by Min Kim on 8/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class BookTableController: UIViewController {
    
    lazy var versesDataManager = VersesDataManager()
    weak var changeChapterDelegate: ChangeChapterDelegate?
    weak var saveVerseDelegate: SaveVerseDelegate?
    var currentChapter = 0 {
        didSet {
            bottomContainerView.currentChapter = currentChapter
        }
    }
    var isSelecting = false
    var selectedVerses = [IndexPath]()
    var dominantHand = "Left"
    var verseArray = [String]()
    var indexPathToSave: IndexPath?
    var numberOfChapters: Int? {
        didSet {
            bottomContainerView.numberOfChapters = numberOfChapters
        }
    }
    let bookTableView: UITableView = {
       let bt = UITableView()
        bt.showsVerticalScrollIndicator = false
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    lazy var indexList: IndexTracker = {
        let il = IndexTracker(frame: .zero, indexList: Array(1...verseArray.count).map({String($0)}), height: view.frame.height - 250)
        il.translatesAutoresizingMaskIntoConstraints = false
        return il
    }()
    
    lazy var bottomContainerView: ChapterView = {
       let bc = ChapterView()
        bc.translatesAutoresizingMaskIntoConstraints = false
        bc.backgroundColor = .white
        return bc
    }()
    
    var saveVerseView: SaveVerseView?
    
    deinit {
        verseArray = []
        print("deinit booktable")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dominantHand = UserDefaults.standard.string(forKey: "DominantHand") ?? "Left"
        setupViews()
        setupDelegates()
    }
    
    func setupDelegates() {
        indexList.delegate = self
        bottomContainerView.chapterPressDelegate = self
    }
    
    func setupViews() {
        bottomContainerView.updateProgressBar()
        view.addSubview(bookTableView)
        view.addSubview(indexList)
        view.addSubview(bottomContainerView)
        view.backgroundColor = .white
        let rightButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didPressSelect))
        navigationItem.rightBarButtonItem = rightButton
        layoutViews()
        setupTableView()
    }
    
    @objc func didPressSelect(_ sender: UIBarButtonItem) {
        if sender.title == "Select" {
            sender.title = "Save"
            isSelecting = true
        } else {
            sender.title = "Select"
            isSelecting = false
            if !selectedVerses.isEmpty {
                var bibleVerses = [BibleVerse]()
                guard let book = navigationItem.title else {return}
                selectedVerses.forEach { (indexPath) in
                    let bibleVerse = BibleVerse(book: book, chapter: currentChapter, verse: indexPath.row + 1, text: verseArray[indexPath.row])
                    bibleVerses.append(bibleVerse)
                    bookTableView.deselectRow(at: indexPath, animated: true)
                }
                guard let savedVerses = SavedVerse(bibleVerses: bibleVerses, noteName: nil, sectionName: nil) else {return}
                var generator: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
                versesDataManager.saveToCoreData(bibleVerse: savedVerses)
                selectedVerses.removeAll()
                generator?.prepare()
                generator?.selectionChanged()
                generator = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        guard let newDominantHand = UserDefaults.standard.string(forKey: "DominantHand") else {return}
        if dominantHand != newDominantHand {
            changeChapterDelegate?.closeController()
        }
    }
    
    func setupTableView() {
        bookTableView.delegate = self
        bookTableView.dataSource = self
        bookTableView.register(BookTableViewCell.self, forCellReuseIdentifier: "cell")
        bookTableView.estimatedRowHeight = 60
        bookTableView.rowHeight = UITableViewAutomaticDimension
        bookTableView.separatorStyle = .none
        bookTableView.allowsMultipleSelection = true
        bookTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    var indexListLeadingAnchor: NSLayoutConstraint?
    var indexListTrailingAnchor: NSLayoutConstraint?
    
    func setDominantHandIndexLayout() {
        if dominantHand == "Left" {
            indexListLeadingAnchor = indexList.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
            indexListLeadingAnchor?.isActive = true
        } else {
            indexListTrailingAnchor = indexList.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            indexListTrailingAnchor?.isActive = true
        }
    }
    
    func formatedVerse(for indexPath: IndexPath) -> String {
        let cell = bookTableView.cellForRow(at: indexPath) as! BookTableViewCell
        guard var word = cell.bibleVerse else {return ""}
        guard let book = self.navigationItem.title else {return ""}
        let chapter = self.currentChapter
        let verse = indexPath.row + 1
        word += "\n\(book) \(chapter):\(verse)"
        return word
    }
    
}

extension BookTableController: IndexListDelegate {
    func pressedIndex(at index: Int) {
        if index < 0 || index > (verseArray.count - 1) {
            return
        }
        var generator: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
        let indexPath = IndexPath(row: index, section: 0)
        UIView.animate(withDuration: 0.01) {
            self.bookTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            generator?.prepare()
            generator?.selectionChanged()
            generator = nil
        }
    }
}

extension BookTableController: IndexVerseDelegate {
    
    func moveToVerse(multiplier: Double) {
        let numberOfVersesInCurrentChapter = verseArray.count
        let verse = Int(multiplier * Double(numberOfVersesInCurrentChapter))
        UIView.animate(withDuration: 0.01) {
            self.bookTableView.scrollToRow(at: IndexPath(row: verse, section: 0), at: .top, animated: false)
        }
    }
    
}

extension BookTableController: ChapterPressDelegate {
    func didPressPreviousChapter() {
        bookTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        changeChapterDelegate?.previousChapter()
    }
    
    func didPressNextChapter() {
        bookTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        changeChapterDelegate?.nextChapter()
    }
    
    func didPressChapterLabel(for chapter: Int) {
        bookTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        changeChapterDelegate?.goToChapter(chapter)
    }
    
}

extension BookTableController: DidSelectNoteDelegate {
    func selectedNoteSection(note: String, section: String) {
        guard let book = navigationItem.title else {return}
        guard let indexPath = indexPathToSave else {return}
        let text = verseArray[indexPath.row]
        let verse = indexPath.row + 1
        let bibleVerse = BibleVerse(book: book, chapter: currentChapter, verse: verse, text: text)
        guard let savedVerses = SavedVerse(bibleVerses: [bibleVerse], noteName: note, sectionName: section) else {return}
//        var generator: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
        versesDataManager.saveToCoreData(bibleVerse: savedVerses)
    }
    
    
}

extension BookTableController: CreateNewNoteDelegate {
    func newNote(for text: String, section: String) {
        guard let book = navigationItem.title else {return}
        guard let indexPath = indexPathToSave else {return}
        let verseText = verseArray[indexPath.row]
        let verse = indexPath.row + 1
        let bibleVerse = BibleVerse(book: book, chapter: currentChapter, verse: verse, text: verseText)
        guard let savedVerses = SavedVerse(bibleVerses: [bibleVerse], noteName: text, sectionName: section) else {return}
        //        var generator: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
        versesDataManager.saveToCoreData(bibleVerse: savedVerses)
    }
    
    
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
