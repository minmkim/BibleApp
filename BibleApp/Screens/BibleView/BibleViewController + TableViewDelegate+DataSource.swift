//
//  BibleViewController + TableViewDelegate+DataSource.swift
//  BibleApp
//
//  Created by Min Kim on 10/21/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension BibleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 66
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BibleTableViewCell
            cell.bibleBook = bible.returnBook(for: indexPath.section)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath) as! ChapterTableViewCell
            if selectedBookIndexPath == indexPath {
                cell.chapterCollectionView.isHidden = false
                cell.numberOfChapters = Constants.numberOfChaptersInBibleBooks[indexPath.section]
                cell.chapterCollectionView.reloadData()
            } else {
                cell.numberOfChapters = 0
                cell.chapterCollectionView.isHidden = true
            }
            cell.didSelectChapterCVDelegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == selectedBookIndexPath?.section && indexPath.row == 0 {
            selectedBookIndexPath = nil
            return
        }
        if !(indexPath.row == 1) {
            selectedBookIndexPath = IndexPath(row: 1, section: indexPath.section)
            guard let cell = bibleTableView.cellForRow(at: IndexPath(row: 1, section: indexPath.section)) as? ChapterTableViewCell else {return}
            cell.chapterCollectionView.isHidden = false
            cell.numberOfChapters = Constants.numberOfChaptersInBibleBooks[indexPath.section]
            cell.chapterCollectionView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedBookIndexPath == indexPath {
            return 30
        } else if indexPath.row == 1 {
            return 0
        } else {
            return 50
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if indexList.indexState == .scrollingTable {
            guard let firstCell = bibleTableView.visibleCells.first as? BibleTableViewCell else {return}
            guard let firstBook = firstCell.bibleBook else {return}
            if let index = bible.bookIndex(for: firstBook) {
                indexList.updatePositionOfBookMarker(index: index)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let moreInfo = UITableViewRowAction(style: .default, title: "More Info") { [weak self] (action, indexPath) in
            self?.bibleCoordinatorDelegate?.openBibleWebsite(for: indexPath)
        }
        moreInfo.backgroundColor = MainColor.redOrange
        return [moreInfo]
    }
}
