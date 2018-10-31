//
//  SavedVerseViewController.swift
//  BibleApp
//
//  Created by Min Kim on 10/20/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SavedVerseViewController: UIViewController {
    
    var itemsToDelete = [ItemToDelete]()
    var savedVersesModel: SavedVersesController!
    var controllerState = ControllerState.note
    weak var createNewNoteDelegate: CreateNewNoteDelegate?
    weak var didSelectNoteDelegate: DidSelectNoteDelegate?
    var heightOfRows = [IndexPath:CGFloat]()
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, state: ControllerState, savedVersesModel: SavedVersesController) {
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
        savedVerseTableView.reloadData()
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
            itemsToDelete.removeAll()
            savedVerseTableView.reloadData()
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
        setupEditView()
    }
    
    func setupDelegates() {
        savedVerseTableView.delegate = self
        savedVerseTableView.dataSource = self
    }
    
    var isEditingSections = false
    var actionBarTopAnchor: NSLayoutConstraint?
    
    
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
                    let index = self.getSectionNumberOfCollectionViewRow(from: row)
                    self.createNewNoteDelegate?.newNote(for: text, section: self.savedVersesModel?.getSection(for: index) ?? "")
                }
                self.dismiss(animated: true, completion: nil)
            } else {
                if let text = textField.text {
                    let index = self.getSectionNumberOfCollectionViewRow(from: row)
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
    
    func getSectionNumberOfCollectionViewRow(from index: Int) -> Int {
        return (index - 3) / 2
    }
    
    struct ItemToDelete {
        let section: String
        let note: String?
    }
    
    enum ControllerState {
        case note
        case search
    }
    
}






