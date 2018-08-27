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
    
    var bookDict = [Int: [String]]()

    let bookTableView: UITableView = {
       let bt = UITableView()
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    lazy var indexList: IndexTracker = {
        let il = IndexTracker(frame: .zero, indexList: Array(1...bookDict.count).map({String($0)}), height: view.frame.height - 200)
        il.translatesAutoresizingMaskIntoConstraints = false
        return il
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bookTableView)
        view.addSubview(indexList)
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        setupTableView()
        layoutViews()
        indexList.delegate = self
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
    
    func layoutViews() {
        indexList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        indexList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true
        indexList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        indexList.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        bookTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        bookTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bookTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bookTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        indexList.setFrame(frameHeight: view.frame.height - 200)
    }
    
}

extension BookTableController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return bookDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookDict[section + 1]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!BookTableViewCell
        cell.verse = bookDict[indexPath.section + 1]?[indexPath.row]
        cell.numberLabel.text = String(indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = layoutHeader(chapter: section)
//        return header
        let header = HeaderView(frame: .zero)
        header.chapter = section
        return header
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let save = UITableViewRowAction(style: .default, title: "Save") { (action, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
            guard let book = self.navigationItem.title else {return}
            let chapter = indexPath.section + 1
            let verse = indexPath.row + 1
            guard let text = cell.verseText.text else {return}
            let bibleVerse = BibleVerse(book: book, chapter: chapter, verse: verse, text: text)
            bibleVerse.saveToCoreData()
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
            print("share")
            guard var verse = cell.verse else {return}
            verse += "\n\(String(describing: self.navigationItem.title!)) \(indexPath.section + 1):\(indexPath.row + 1)"
            let activityVC = UIActivityViewController(activityItems: [verse], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        share.backgroundColor = .lightGray
        save.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        return [share, save]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
        guard var word = cell.verse else {return}
        guard let book = navigationItem.title else {return}
        let chapter = indexPath.section + 1
        let verse = indexPath.row + 1
        word += "\n\(book) \(chapter):\(verse)"
        UIPasteboard.general.string = word
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.bookTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        indexList.indexState = .scrollingTable
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if indexList.indexState == .scrollingTable {
            guard let firstCell = bookTableView.visibleCells.first else {return}
            guard let index = bookTableView.indexPath(for: firstCell) else {return}
            indexList.updatePositionOfBookMarker(index: index.section)
            guard let numberOfVersesInSection = bookDict[index.section + 1]?.count else {return}
            let multiplier = Double(index.row)/Double(numberOfVersesInSection)
            guard let header = bookTableView.headerView(forSection: index.section) as? HeaderView else {return}
            header.updateProgressBar(multipler: multiplier)
        }
    }
    
}

extension BookTableController: IndexListDelegate {
    func pressedIndex(at index: Int) {
        if index < 0 || index > (bookDict.count - 1) {
            return
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        let indexPath = IndexPath(row: 0, section: index)
        UIView.animate(withDuration: 0.01) {
            self.bookTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            generator.impactOccurred()
        }
    }
}
