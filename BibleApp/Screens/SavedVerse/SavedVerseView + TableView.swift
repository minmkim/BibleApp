//
//  SavedVerseView + TableView.swift
//  BibleApp
//
//  Created by Min Kim on 10/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension SavedVerseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((savedVersesModel?.getNumberOfSections() ?? 0) * 2) + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch true {
        case indexPath.row == 0:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! SavedVerseHeaderTableViewCell
            cell.headerLabel.text = "Saved Verses"
            cell.savedVerseHeaderDelegate = self
            let customFont = UIFont.systemFont(ofSize: 34, weight: .bold)
            cell.headerLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
            if controllerState == .search {
                cell.addCancelButton()
            }
            cell.selectionStyle = .none
            cell.addButton.removeFromSuperview()
            return cell
        case indexPath.row == 1:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "noSectionVerse", for: indexPath) as! VersesWithoutSectionTableViewCell
            cell.didSelectSavedVersesDelegate = self
            cell.selectionStyle = .none
            savedVersesModel?.loadVersesWithoutSection(completion: { (fetchedVerses) in
                cell.savedVerses = fetchedVerses
                DispatchQueue.main.async {
                    cell.savedVerseCollectionView.reloadData()
                }
            })
            if cell.savedVerses.count > 0 {
                heightOfRows[indexPath] = 150
            } else {
                heightOfRows[indexPath] = 0
            }
            return cell
        case indexPath.row % 2 == 0:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! SavedVerseHeaderTableViewCell
            let index = (indexPath.row - 2)/2
            cell.headerLabel.attributedText = setAttributedText(for: indexPath, text: savedVersesModel?.getSection(for: index) ?? "")
            cell.row = indexPath.row
            cell.savedVerseHeaderDelegate = self
            cell.selectionStyle = .none
            return cell
        default:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedVerseTableViewCell
            cell.didPressNoteDelegate = self
            cell.didDragVerseDelegate = self
            cell.selectionStyle = .none
            cell.row = indexPath.row
            let index = getSectionNumberOfCollectionViewRow(from: indexPath.row)
            let notes = savedVersesModel?.getNotes(for: index)
            cell.notes = notes ?? []
            setIndexPathHeightDictionary(for: notes?.count ?? 0, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (0...1).contains(indexPath.row) {
            return
        }
        
        if (indexPath.row - 2) % 2 == 0 && isEditingSections {
            guard let cell = savedVerseTableView.cellForRow(at: indexPath) as? SavedVerseHeaderTableViewCell else {return}
            guard let text = cell.headerLabel.text else {return}
            let index = (indexPath.row - 2)/2
            let section = savedVersesModel?.getSection(for: index) ?? ""
            if itemsToDeleteIndexPaths.contains(indexPath) {
                itemsToDeleteIndexPaths = itemsToDeleteIndexPaths.filter({$0 != indexPath})
                itemsToDelete = itemsToDelete.filter({$0 != ItemToDelete(section: section, note: nil)})
            } else {
                itemsToDeleteIndexPaths.append(indexPath)
                itemsToDelete.append(ItemToDelete(section: section, note: nil))
            }
            cell.headerLabel.attributedText = setAttributedText(for: indexPath, text: text)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightOfRows[indexPath] {
            return height
        }
        
        if indexPath.row == 0 || indexPath.row % 2 == 0 {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationItem.title = ""
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationItem.title = "Saved Verses"
        }
    }
    
}
