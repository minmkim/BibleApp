//
//  SavedVerseView + SavedVerseBar.swift
//  BibleApp
//
//  Created by Min Kim on 10/30/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension SavedVerseViewController: SaveVerseBarDelegate {
    
    func didPressTrash() {
        for item in itemsToDelete {
            if let note = item.note {
                savedVersesModel.removeNote(note: note, section: item.section)
            } else {
                savedVersesModel.removeSection(for: item.section)
            }
        }
        if !versesToDelete.isEmpty {
            versesToDelete.forEach({savedVersesModel.deleteVerse($0)})
            if let cell = savedVerseTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? VersesWithoutSectionTableViewCell {
                cell.removeVerses()
            }
        }
        setupEditView()
    }
    
    func didPressAdd() {
        let alertController = UIAlertController(title: "New Section", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.font = UIFont.preferredFont(forTextStyle: .subheadline)
            textField.adjustsFontForContentSizeCategory = true
            textField.autocapitalizationType = .words
            textField.placeholder = "New Section Name"
            textField.addTarget(self, action: #selector(self.textDidChange), for: .editingChanged)
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { (alertAction: UIAlertAction!) -> Void in
            let textField = alertController.textFields![0] as UITextField
            self.savedVersesModel?.saveNewSection(for: textField.text ?? "")
            self.savedVerseTableView.reloadData()
            self.setupEditView()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.view.tintColor = MainColor.redOrange
        saveAction.isEnabled = false
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}
