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
    var currentChapter = 0 {
        didSet {
            bottomContainerView.currentChapter = currentChapter
        }
    }
    var isSelecting = false
    var selectedVerses = [IndexPath]()
    
    var verseArray = [String]()
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
    
    deinit {
        verseArray = []
        changeChapterDelegate?.closedController()
        print("deinit booktable")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dominantHand = UserDefaults.standard.string(forKey: "DominantHand")
        if dominantHand == "" {
            UserDefaults.standard.set("Left", forKey: "DominantHand")
        }
        bottomContainerView.updateProgressBar()
        view.addSubview(bookTableView)
        view.addSubview(indexList)
        view.addSubview(bottomContainerView)
        view.backgroundColor = .white
        let rightButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didPressSelect))
        navigationItem.rightBarButtonItem = rightButton
        layoutViews()
        indexList.delegate = self
        bottomContainerView.chapterPressDelegate = self
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
                guard let savedVerses = SavedVerse(bibleVerses: bibleVerses) else {return}
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
    
    var dominantHand: String?
    var indexListLeadingAnchor: NSLayoutConstraint?
    var indexListTrailingAnchor: NSLayoutConstraint?
    
    func layoutViews() {
        bottomContainerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomContainerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomContainerView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        indexList.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        indexList.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: -12).isActive = true
        if dominantHand == "Left" {
            indexListLeadingAnchor = indexList.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
            indexListLeadingAnchor?.isActive = true
        } else {
            indexListTrailingAnchor = indexList.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            indexListTrailingAnchor?.isActive = true
        }
        
        bookTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        bookTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bookTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bookTableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
    }
    
}

extension BookTableController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!BookTableViewCell
        cell.bibleVerse = verseArray[indexPath.row]
        cell.numberLabel.text = String(indexPath.row + 1)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let save = UITableViewRowAction(style: .default, title: "Save") { [weak self] (action, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
            guard let book = self?.navigationItem.title else {return}
            let chapter = indexPath.section + 1
            let verse = indexPath.row + 1
            guard let text = cell.verseText.text else {return}
            let bibleVerse = SavedVerse(book: book, chapter: chapter, verse: verse, text: text)
            self?.versesDataManager.saveToCoreData(bibleVerse: bibleVerse)
        }
        
        let copy = UITableViewRowAction(style: .default, title: "Copy") { (action, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
            guard var word = cell.bibleVerse else {return}
            guard let book = self.navigationItem.title else {return}
            let chapter = indexPath.section + 1
            let verse = indexPath.row + 1
            word += "\n\(book) \(chapter):\(verse)"
            UIPasteboard.general.string = word
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.bookTableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
            guard var verse = cell.bibleVerse else {return}
            verse += "\n\(String(describing: self.navigationItem.title!)) \(indexPath.section + 1):\(indexPath.row + 1)"
            let activityVC = UIActivityViewController(activityItems: [verse], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        share.backgroundColor = .lightGray
        copy.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
        save.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        return [share, copy, save]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelecting {
            if selectedVerses.contains(indexPath) {
                selectedVerses.removeAll { (index) -> Bool in
                    index == indexPath
                }
            } else {
                selectedVerses.append(indexPath)
            }
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
            guard var word = cell.bibleVerse else {return}
            guard let book = navigationItem.title else {return}
            let chapter = indexPath.section + 1
            let verse = indexPath.row + 1
            word += "\n\(book) \(chapter):\(verse)"
            UIPasteboard.general.string = word
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.bookTableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if indexList.indexState == .scrollingTable {
            guard let firstCell = bookTableView.visibleCells.first else {return}
            guard let index = bookTableView.indexPath(for: firstCell) else {return}
            indexList.updatePositionOfBookMarker(index: index.row)
        }
    }
    
    func newChapter() {
        bookTableView.reloadData()
        indexList.newChapter(for: Array(1...verseArray.count).map({String($0)}))
        self.view.layoutIfNeeded()
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

protocol ChangeChapterDelegate: class {
    func previousChapter()
    func nextChapter()
    func goToChapter(_ chapter: Int)
    func closedController()
}
