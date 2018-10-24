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
    
    var savedVersesModel: SavedVerses!
    var controllerState = ControllerState.note
    weak var createNewNoteDelegate: CreateNewNoteDelegate?
    weak var didSelectNoteDelegate: DidSelectNoteDelegate?
    var heightOfRows = [IndexPath:CGFloat]()
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, state: ControllerState, savedVersesModel: SavedVerses) {
        controllerState = state
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.savedVersesModel = savedVersesModel
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
        sv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        sv.backgroundColor = .white
        sv.separatorStyle = .none
        sv.allowsSelection = false
        return sv
    }()
    
    lazy var actionBar: SavedVerseBar = {
        let ab = SavedVerseBar()
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.saveVerseBarDelegate = self
        return ab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        layoutViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedVersesModel?.loadHeadersAndNotes()
        DispatchQueue.main.async {
            self.savedVerseTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
        
//        savedVerseTableView.cellForRow(at: IndexPath(row: 1, section: 0))?.layoutIfNeeded()
    }

    func setupViews() {
        view.addSubview(containerView)
       view.addSubview(actionBar)
        containerView.addSubview(savedVerseTableView)
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        let rightButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didPressEdit))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setupEditView() {
        actionBarTopAnchor?.isActive = false
        if isEditingSections { //finished editing
            isEditingSections = !isEditingSections
            navigationItem.rightBarButtonItem?.title = "Edit"
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.actionBarTopAnchor = self.actionBar.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (self.tabBarController?.tabBar.frame.size.height ?? 50))
                self.actionBarTopAnchor?.isActive = true
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else { //editing
            isEditingSections = !isEditingSections
            navigationItem.rightBarButtonItem?.title = "Cancel"
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.actionBarTopAnchor = self.actionBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
                self.actionBarTopAnchor?.isActive = true
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    @objc func didPressEdit() {
//        savedVerseTableView.reloadData()
        setupEditView()
    }
    
    func setupDelegates() {
        savedVerseTableView.delegate = self
        savedVerseTableView.dataSource = self
    }
    
    var isEditingSections = false
    var actionBarTopAnchor: NSLayoutConstraint?
    
    func layoutViews() {
        containerView.fillContainer(for: view)
        savedVerseTableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        savedVerseTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        savedVerseTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        savedVerseTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        actionBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        actionBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        actionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        actionBarTopAnchor = actionBar.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        actionBarTopAnchor?.isActive = true
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
                    self.createNewNoteDelegate?.newNote(for: text, section: self.savedVersesModel?.getSection(for: index) ?? "")
                }
                self.dismiss(animated: true, completion: nil)
            } else {
                if let text = textField.text {
                    let index = (row - 3)/2
                    self.savedVersesModel?.saveNewNote(newNote: text, index: index)
                    self.savedVerseTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
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
    
    func setIndexPathHeightDictionary(for count: Int, indexPath: IndexPath) {
        if count == 0 {
            heightOfRows[indexPath] = 0
        } else if count == 1 {
            heightOfRows[indexPath] = 74
        } else {
            heightOfRows[indexPath] = 154
        }
        
    }
    
}

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
            let customFont = UIFont.systemFont(ofSize: 34, weight: .bold)
            cell.headerLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
            if controllerState == .search {
                cell.addCancelButton()
            }
            cell.addButton.removeFromSuperview()
            return cell
        case indexPath.row == 1:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "noSectionVerse", for: indexPath) as! VersesWithoutSectionTableViewCell
            savedVersesModel?.loadVersesWithoutSection(completion: { (fetchedVerses) in
                cell.savedVerses = fetchedVerses
                cell.savedVerseCollectionView.reloadData()
            })
            if cell.savedVerses.count > 0 {
                heightOfRows[indexPath] = 150
            } else {
                heightOfRows[indexPath] = 0
            }
            print(cell.savedVerses.count)
            return cell
        case indexPath.row % 2 == 0:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! SavedVerseHeaderTableViewCell
            let index = (indexPath.row - 2)/2
            cell.headerLabel.text = savedVersesModel?.getSection(for: index)
            cell.row = indexPath.row
            cell.didPressAddNoteDelegate = self
            return cell
        default:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedVerseTableViewCell
            cell.didPressNoteDelegate = self
            cell.didDragVerseDelegate = self
            cell.row = indexPath.row
            let index = (indexPath.row - 3)/2
            let notes = savedVersesModel?.getNotes(for: index)
            cell.notes = notes ?? []
            setIndexPathHeightDictionary(for: notes?.count ?? 0, indexPath: indexPath)
            return cell
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

extension SavedVerseViewController: DidPressNoteDelegate {
    func didPressNote(at indexPath: IndexPath, row: Int, note: String) {
        let index = (row - 3)/2
        switch controllerState {
        case .note:
            let controller = VerseViewController()
            controller.navigationItem.title = note
            controller.savedVersesModel = savedVersesModel
            controller.savedVerses = savedVersesModel?.loadVerses(for: note) ?? []
            navigationController?.pushViewController(controller, animated: true)
        case .search:
            didSelectNoteDelegate?.selectedNoteSection(note: note, section: savedVersesModel?.getSection(for: index) ?? "")
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}

extension SavedVerseViewController: DidPressAddNoteDelegate {
    func didPressAddNote(at row: Int) {
        addNewNote(for: row+1)
        switch  controllerState {
        case .note:
            print("note")
        case .search:
            print("search")
        }
    }
}

extension SavedVerseViewController: SaveVerseBarDelegate {
    func didPressTrash() {
        
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

extension SavedVerseViewController: DidDragVerseDelegate {
    func didDragVerse(for verse: SavedVerse, note: String, row: Int) {
        let index = (row - 3)/2
        guard let section = savedVersesModel?.getSection(for: index) else {return}
        
        DispatchQueue.main.async {
            let cell = self.savedVerseTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! VersesWithoutSectionTableViewCell
            if let indexPath = cell.draggedIndexPath {
                cell.savedVerses.remove(at: indexPath.item)
                cell.savedVerseCollectionView.deleteItems(at: [indexPath])
            }
            
            if cell.savedVerses.isEmpty {
                self.heightOfRows[IndexPath(row: 1, section: 0)] = 0
                self.savedVerseTableView.beginUpdates()
                self.savedVerseTableView.endUpdates()
            }
        }
        
        savedVersesModel?.updateVerseToNote(verse: verse, note: note, section: section)
    }
    
    
}


protocol CreateNewNoteDelegate: class {
    func newNote(for text: String, section: String)
}

protocol DidSelectNoteDelegate: class {
    func selectedNoteSection(note: String, section: String)
}
