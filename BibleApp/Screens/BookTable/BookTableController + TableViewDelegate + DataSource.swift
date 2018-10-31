//
//  BookTableController + TableViewDelegate + DataSource.swift
//  BibleApp
//
//  Created by Min Kim on 10/21/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension BookTableController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!BookTableViewCell
        cell.dominantHand = dominantHand
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
            guard let chapter = self?.currentChapter else {return}
            let verse = indexPath.row + 1
            guard let text = cell.verseText.text else {return}
            let bibleVerse = SavedVerse(book: book, chapter: chapter, verse: verse, text: text)
            self?.versesDataManager.saveToCoreData(bibleVerse: bibleVerse)
        }
        
        let saveTo = UITableViewRowAction(style: .default, title: "Save To:") { [weak self] (action, indexPath) in
            self?.saveVerseDelegate?.presentSaveVerses()
            //            let controller = SavedVerseViewController(state: .search)
            //            controller.didSelectNoteDelegate = self
            //            controller.createNewNoteDelegate = self
            self?.indexPathToSave = indexPath
            //            self?.present(controller, animated: true, completion: nil)
        }
        
        let copy = UITableViewRowAction(style: .default, title: "Copy") { (action, indexPath) in
            let verseText = self.formatedVerse(for: indexPath)
            UIPasteboard.general.string = verseText
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.bookTableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            let verseText = self.formatedVerse(for: indexPath)
            let activityVC = UIActivityViewController(activityItems: [verseText], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        share.backgroundColor = .lightGray
        copy.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
        save.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        return [share, copy, save, saveTo]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isSelecting {
            if selectedVerses.contains(indexPath) {
                selectedVerses.removeAll { (index) -> Bool in
                    index == indexPath
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelecting {
            selectedVerses.append(indexPath)
        } else {
            let verseText = self.formatedVerse(for: indexPath)
            UIPasteboard.general.string = verseText
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
