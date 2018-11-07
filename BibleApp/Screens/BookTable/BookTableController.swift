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

final class BookTableController: UIViewController {
    
    var savedVersesController: SavedVersesController!
    weak var changeChapterDelegate: ChangeChapterDelegate?
    weak var saveVerseDelegate: SaveVerseDelegate?
    var currentChapter = 0 {
        didSet {
            bottomContainerView.currentChapter = currentChapter
        }
    }
    var isSelecting = false
    var selectedVerses = [IndexPath]()
    var dominantHand = DominantHand.left.rawValue
    var verseArray = [BibleVerse]()
    var indexPathToSave: IndexPath?
    var numberOfChapters: Int? {
        didSet {
            bottomContainerView.numberOfChapters = numberOfChapters
        }
    }
    var indexListLeadingAnchor: NSLayoutConstraint?
    var indexListTrailingAnchor: NSLayoutConstraint?
    
    let bookTableView: UITableView = {
       let bt = UITableView()
        bt.showsVerticalScrollIndicator = false
        return bt
    }()
    
    var indexList: IndexTracker?
    
    lazy var bottomContainerView: ChapterView = {
       let bc = ChapterView()
        bc.backgroundColor = .white
        return bc
    }()
    
    deinit {
        verseArray = []
        print("deinit booktable")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
    }
    
    func setupDelegates() {
        bottomContainerView.chapterPressDelegate = self
    }
    
    func setupController(numberOfChapters: Int, currentChapter: Int, book: String) {
        self.currentChapter = currentChapter
        self.numberOfChapters = numberOfChapters
        navigationItem.title = book
    }
    
    func setupIndexList(for row: Int) {
        indexList = IndexTracker(frame: .zero, indexList: Array(1...(row)).map({String($0)}), height: view.frame.height - 250)
        indexList?.delegate = self
        view.addSubviewsUsingAutoLayout(indexList!)
        indexList?.topAnchor.constrain(to: view.safeAreaLayoutGuide.topAnchor, with: 12)
        indexList?.bottomAnchor.constrain(to: bottomContainerView.topAnchor, with: -12)
        indexList?.widthAnchor.constrain(to: 25)
        setDominantHandIndexLayout()
        
    }
    
    func setupViews() {
        dominantHand = UserDefaults.standard.string(forKey: "DominantHand") ?? DominantHand.left.rawValue
        bottomContainerView.updateProgressBar()
        view.addSubviewsUsingAutoLayout(bookTableView, bottomContainerView)
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
                selectedVerses.forEach { (indexPath) in
                    bibleVerses.append(verseArray[indexPath.row])
                    bookTableView.deselectRow(at: indexPath, animated: true)
                }
                guard let savedVerse = SavedVerse(bibleVerses: bibleVerses) else {return}
                var generator: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
                savedVersesController.saveVerse(for: savedVerse)
                selectedVerses.removeAll()
                generator?.prepare()
                generator?.selectionChanged()
                generator = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        guard let newDominantHand = UserDefaults.standard.string(forKey: "DominantHand") else {return}
        if dominantHand != newDominantHand {
            changeChapterDelegate?.closeController()
        }
        guard let firstVerse = verseArray.first else {return}
        if firstVerse.version != (UserDefaults.standard.string(forKey: "BibleVersion") ?? "NIV1984") {
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
    
    func setDominantHandIndexLayout() {
        if dominantHand == DominantHand.left.rawValue {
            indexListLeadingAnchor = indexList?.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
            indexListLeadingAnchor?.isActive = true
        } else {
            indexListTrailingAnchor = indexList?.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            indexListTrailingAnchor?.isActive = true
        }
    }
    
    func formattedVerse(for indexPath: IndexPath) -> String {
        guard let cell = bookTableView.cellForRow(at: indexPath) as? BookTableViewCell else {return ""}
        guard let verse = cell.bibleVerse else {return ""}
        return verse.formattedVerseAndText()
    }
    
    func getVerse() -> BibleVerse? {
        guard let indexPath = indexPathToSave else {return nil}
        guard let cell = bookTableView.cellForRow(at: indexPath) as? BookTableViewCell else {return nil}
        guard let verse = cell.bibleVerse else {return nil}
        return verse
    }
    
}

extension BookTableController: IndexListDelegate {
    func pressedIndex(at index: Int) {
        if index < 0 || index > (verseArray.count - 1) { return }
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
        if let bibleVerse = getVerse() {
            guard let savedVerse = SavedVerse(bibleVerses: [bibleVerse], noteName: note, sectionName: section) else {return}
            savedVersesController.saveVerse(for: savedVerse)
        }
    }
    
    
}

extension BookTableController: CreateNewNoteDelegate {
    func newNote(for text: String, section: String) {
        if let bibleVerse = getVerse() {
            guard let savedVerse = SavedVerse(bibleVerses: [bibleVerse], noteName: text, sectionName: section) else {return}
            savedVersesController.saveNewNoteWithSection(newNote: text, section: section)
            savedVersesController.saveVerse(for: savedVerse)
        }
        
    }
    
    
}

