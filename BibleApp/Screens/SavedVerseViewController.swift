//
//  SavedVerseViewController.swift
//  BibleApp
//
//  Created by Min Kim on 10/20/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SavedVerseViewController: UIViewController {
    
    enum ControllerState {
        case note
        case search
    }
    
    
    var savedVersesModel: SavedVerses?
    var controllerState = ControllerState.note
    weak var createNewNoteDelegate: CreateNewNoteDelegate?
    weak var didSelectNoteDelegate: DidSelectNoteDelegate?
    var heightOfRows = [IndexPath:CGFloat]()
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, state: ControllerState) {
        controllerState = state
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        savedVersesModel = SavedVerses()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let savedVerseTableView: UITableView = {
       let sv = UITableView(frame: .zero, style: .plain)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.register(SavedVerseTableViewCell.self, forCellReuseIdentifier: "cell")
        sv.register(SavedVerseHeaderTableViewCell.self, forCellReuseIdentifier: "header")
        sv.register(VersesWithoutSectionTableViewCell.self, forCellReuseIdentifier: "noSectionVerse")
        sv.register(UITableViewCell.self, forCellReuseIdentifier: "test")
        sv.backgroundColor = .white
        sv.separatorStyle = .none
        sv.allowsSelection = false
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        layoutViews()
    }
    
    func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(savedVerseTableView)
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        let rightButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didPressAdd))
        navigationItem.rightBarButtonItem = rightButton
        
    }
    
    @objc func didPressAdd() {
        print("did press add")
        savedVerseTableView.reloadData()
    }
    
    func setupDelegates() {
        savedVerseTableView.delegate = self
        savedVerseTableView.dataSource = self
    }
    
    var rowHeight: CGFloat = 100
    
    @objc func test() {
        guard let cell = savedVerseTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? VersesWithoutSectionTableViewCell else {return}
        rowHeight = cell.savedVerseCollectionView.contentSize.height * 2
        savedVerseTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
    }
    
    func layoutViews() {
        containerView.fillContainer(for: view)
        savedVerseTableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        savedVerseTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        savedVerseTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        savedVerseTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        let alertController: UIAlertController = self.presentedViewController as! UIAlertController
        let addAction: UIAlertAction = alertController.actions[0]
        addAction.isEnabled = ((sender.text?.count ?? 0) > 0)
    }
    
    func addNewNote(for row: Int) {
        let alertController = UIAlertController(title: "New Note", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.font = UIFont.preferredFont(forTextStyle: .subheadline)
            textField.adjustsFontForContentSizeCategory = true
            textField.autocapitalizationType = .words
            textField.placeholder = "New Note Name"
            textField.addTarget(self, action: #selector(self.textDidChange), for: .editingChanged)
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { (alertAction: UIAlertAction!) -> Void in 
            let textField = alertController.textFields![0] as UITextField
            
            if self.controllerState == .search {
                if let text = textField.text {
                    let index = (row - 3)/2
                    
                    self.createNewNoteDelegate?.newNote(for: text, section: self.savedVersesModel?.headerLabels[index] ?? "")
                }
                self.dismiss(animated: true, completion: nil)
            } else {
                if let text = textField.text {
                    let dataManager = VersesDataManager()
                    let index = (row - 3)/2
                    dataManager.saveNewNote(for: text, section: self.savedVersesModel?.headerLabels[index] ?? "")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.view.tintColor = MainColor.redOrange
        saveAction.isEnabled = false
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension SavedVerseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((savedVersesModel?.headerLabels.count ?? 0) * 2) + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch true {
        case indexPath.row == 0:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! SavedVerseHeaderTableViewCell
            cell.headerLabel.text = "Saved Verses"
            let customFont = UIFont.systemFont(ofSize: 34, weight: .bold)
            cell.headerLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
            if controllerState == .search {
                cell.addCancelButton()
            }
            cell.addButton.removeFromSuperview()
            return cell
        case indexPath.row == 1:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "noSectionVerse", for: indexPath) as! VersesWithoutSectionTableViewCell
            return cell
        case indexPath.row % 2 == 0:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! SavedVerseHeaderTableViewCell
            let index = (indexPath.row - 2)/2
            cell.headerLabel.text = savedVersesModel?.headerLabels[index]
            cell.row = indexPath.row
            cell.didPressAddNoteDelegate = self
            return cell
        default:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedVerseTableViewCell
            cell.didPressNoteDelegate = self
            cell.row = indexPath.row
            let index = (indexPath.row - 3)/2
            let notes = savedVersesModel?.notesLabels[savedVersesModel?.headerLabels[index] ?? ""] ?? []
            cell.notes = notes
            if notes.count == 0 {
                heightOfRows[indexPath] = 0
            } else if notes.count == 1 {
                heightOfRows[indexPath] = 74
            } else {
                heightOfRows[indexPath] = 154
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightOfRows[indexPath] {
            return height
        }
        
        if indexPath.row == 0 {
            return 50
        } else if indexPath.row == 1 {
            return rowHeight
        } else if indexPath.row % 2 == 0 {
            return 50
        } else {
            return 200
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

extension SavedVerseViewController: DidPressNoteDelegate {
    func didPressNote(at indexPath: IndexPath, row: Int, note: String) {
        let index = (row - 3)/2
        print("pressed at \(indexPath), \(row)")
        switch controllerState {
        case .note:
            let controller = VerseViewController()
            controller.savedVerses = savedVersesModel?.savedVerses[savedVersesModel?.headerLabels[index] ?? ""]?[note] ?? []
            navigationController?.pushViewController(controller, animated: true)
        case .search:
            didSelectNoteDelegate?.selectedNoteSection(note: note, section: savedVersesModel?.headerLabels[index] ?? "")
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}

extension SavedVerseViewController: DidPressAddNoteDelegate {
    func didPressAddNote(at row: Int) {
        addNewNote(for: row+1)
        switch  controllerState {
        case .note:
            print("noted")
        case .search:
            print("search")
        }
    }
}


protocol CreateNewNoteDelegate: class {
    func newNote(for text: String, section: String)
}

protocol DidSelectNoteDelegate: class {
    func selectedNoteSection(note: String, section: String)
}
