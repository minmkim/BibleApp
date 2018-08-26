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
    
    var savedVerses = [BibleVerse]()
    let dataManager = VersesDataManager()
    var isEditingVerses = false
    var indexPathToDelete = [IndexPath]()
    
    let verseCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(VerseCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return cv
    }()
    
    let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let editView: UIView = {
        let ev = UIView()
        ev.translatesAutoresizingMaskIntoConstraints = false
        ev.backgroundColor = UIColor.groupTableViewBackground
        return ev
    }()

    let deleteButton: UIButton = {
       let db = UIButton()
        db.translatesAutoresizingMaskIntoConstraints = false
        db.addTarget(self, action: #selector(didPressDelete), for: .touchUpInside)
        db.setTitle("Delete", for: .normal)
        db.setTitleColor(UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0), for: .normal)
        return db
    }()
    
    @objc func didPressDelete() {
        indexPathToDelete.forEach { (indexPath) in
            dataManager.deleteVerse(for: savedVerses[indexPath.row])
        }
        savedVerses.removeIndexPaths(at: indexPathToDelete)
        verseCollectionView.performBatchUpdates({
            verseCollectionView.deleteItems(at: indexPathToDelete)
        }) { (true) in
            self.indexPathToDelete.removeAll()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedVerses.removeAll()
        savedVerses = dataManager.loadVerses()
        verseCollectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Saved Verses"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(verseCollectionView)
        view.addSubview(editView)
        editView.addSubview(deleteButton)
        verseCollectionView.delegate = self
        verseCollectionView.dataSource = self
        layoutViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didPressEdit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
    }
    
    @objc func didPressEdit(sender: UIBarButtonItem) {
        editViewTopAnchor?.isActive = false
        if isEditingVerses {
            isEditingVerses = !isEditingVerses
            sender.title = "Edit"
            removeDeleteImage()
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                self.editViewTopAnchor = self.editView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: +20)
                self.editViewTopAnchor?.isActive = true
                self.view.layoutIfNeeded()
            }, completion:{ (true) in
                self.tabBarController?.tabBar.isHidden = false
            })
        } else {
            isEditingVerses = !isEditingVerses
            sender.title = "Done"
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.tabBarController?.tabBar.isHidden = true
                self.editViewTopAnchor = self.editView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.size.height ?? 50))
                self.editViewTopAnchor?.isActive = true
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
    
    var editViewTopAnchor: NSLayoutConstraint?
    
    func layoutViews() {
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        verseCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        verseCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        verseCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        verseCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        editViewTopAnchor = editView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        editViewTopAnchor?.isActive = true
        editView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        editView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        deleteButton.centerXAnchor.constraint(equalTo: editView.centerXAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: editView.topAnchor, constant: 22).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 8).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func transitionToBibleViewController(for verse: BibleVerse) {
        let bibleNavController = self.tabBarController?.viewControllers![0] as! UINavigationController
        bibleNavController.popToRootViewController(animated: false)
        let bibleViewController = bibleNavController.viewControllers.first as! BibleViewController
        tabBarController?.selectedViewController = bibleNavController
        guard let dict = bibleViewController.bible.bookVerseDictionary[verse.book] else {return}
        let book = verse.book
        let chapter = verse.chapter
        let verse = verse.verse
        bibleViewController.presentBookAndScroll(for: dict, book: book, chapter: chapter, verse: verse)
    }
    
}

extension VerseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedVerses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = verseCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VerseCollectionViewCell
        cell.verse = savedVerses[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80 //Arbitrary number
        let verse = savedVerses[indexPath.item]
        height = estimatedFrameForText(text: verse.text).height + 44
        return CGSize(width: verseCollectionView.frame.width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: (view.frame.width - 56), height: 500)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = verseCollectionView.cellForItem(at: indexPath) as! VerseCollectionViewCell
        if !isEditingVerses {
            guard let verse = cell.verse else {return}
            transitionToBibleViewController(for: verse)
        } else {
            if cell.deleteImage.isHidden {
                cell.deleteImage.isHidden = false
                indexPathToDelete.append(indexPath)
            } else {
                cell.deleteImage.isHidden = true
                indexPathToDelete = indexPathToDelete.filter( {$0 != indexPath})
                print(indexPathToDelete)
            }
        }
    }
    
}
