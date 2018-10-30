//
//  VerseViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit
import CoreData

class VerseViewController: UIViewController {
    
    weak var savedVerseDelegate: SavedVerseDelegate?
    var savedVerses = [SavedVerse]()
    var savedVerseController: SavedVerseController!
    var isEditingVerses = false
    var indexPathToDelete = [IndexPath]()
    var actionBarTopAnchor: NSLayoutConstraint?
    var didLongPress = false
    
    let verseCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(VerseCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 48, right: 0)
        return cv
    }()
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        return cv
    }()
    
    lazy var actionBar: SavedVerseActionBar = {
       let ab = SavedVerseActionBar()
        ab.savedVerseActionBarDelegate = self
        return ab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedVerses.removeAll()
        savedVerseController.getSavedVerses { [unowned self] (fetchedVerses) in
            self.savedVerses = fetchedVerses
            DispatchQueue.main.async {
                self.verseCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isEditingVerses {
            removeDeleteImage()
            indexPathToDelete.removeAll()
            setupEditView()
        }
    }
    
    func setupViews() {
        navigationItem.title = "Saved Verses"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didPressEdit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
        view.backgroundColor = .white
        view.addSubviewsUsingAutoLayout(containerView, verseCollectionView, actionBar)
        verseCollectionView.delegate = self
        verseCollectionView.dataSource = self
        layoutViews()
    }
    
    @objc func didPressEdit(sender: UIBarButtonItem) {
        if sender.title == "Cancel" {
            removeDeleteImage()
        }
        setupEditView()
    }
    
    func setupEditView() {
        actionBarTopAnchor?.isActive = false
        if isEditingVerses { //finished editing
            didLongPress = false
            isEditingVerses = !isEditingVerses
            verseCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            navigationItem.rightBarButtonItem?.title = "Edit"
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.actionBarTopAnchor = self.actionBar.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (self.tabBarController?.tabBar.frame.size.height ?? 50))
                self.actionBarTopAnchor?.isActive = true
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else { //editing
            isEditingVerses = !isEditingVerses
            verseCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
            navigationItem.rightBarButtonItem?.title = "Cancel"
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.actionBarTopAnchor = self.actionBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
                self.actionBarTopAnchor?.isActive = true
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func removeDeleteImage() {
        if indexPathToDelete.count != 0 {
            indexPathToDelete.forEach({ (indexPath) in
                let cell = self.verseCollectionView.cellForItem(at: indexPath) as! VerseCollectionViewCell
                cell.deleteImage.isHidden = true
            })
        }
        indexPathToDelete.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func didLongPressCell(_ recognizer: UILongPressGestureRecognizer) {
        if !didLongPress {
            didLongPress.toggle()
            let touchPoint = recognizer.location(in: self.view)
            if let indexPath = verseCollectionView.indexPathForItem(at: touchPoint) {
                if let cell = verseCollectionView.cellForItem(at: indexPath) as? VerseCollectionViewCell {
                    if cell.deleteImage.isHidden {
                        cell.deleteImage.isHidden = false
                        indexPathToDelete.append(indexPath)
                    } else {
                        cell.deleteImage.isHidden = true
                        indexPathToDelete = indexPathToDelete.filter( {$0 != indexPath})
                    }
                }
            }
            setupEditView()
        }
    }

}


