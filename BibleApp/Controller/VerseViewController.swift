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
    var savedVerses = [BibleVerse]()
    let dataManager = VersesDataManager()
    var isEditingVerses = false
    var indexPathToDelete = [IndexPath]() {
        didSet {
            if indexPathToDelete.isEmpty {
                deleteButton.setTitleColor(UIColor.lightGray, for: .normal)
                deleteButton.isEnabled = false
            } else {
//                deleteButton.setTitleColor(UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0), for: .normal)
                deleteButton.setTitleColor(.white, for: .normal)
                deleteButton.isEnabled = true
            }
        }
    }
    
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

    let deleteButton: UIButton = {
       let db = UIButton()
        db.translatesAutoresizingMaskIntoConstraints = false
        db.addTarget(self, action: #selector(didPressDelete), for: .touchUpInside)
        db.setTitle("Delete", for: .normal)
        db.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        db.setTitleColor(UIColor.lightGray, for: .normal)
        db.isUserInteractionEnabled = true
        db.isEnabled = true
        db.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        db.backgroundColor = .red
        return db
    }()
    
    @objc func didPressDelete() {
        indexPathToDelete.forEach { (indexPath) in
            let cell = self.verseCollectionView.cellForItem(at: indexPath) as! VerseCollectionViewCell
            cell.deleteImage.isHidden = true
            dataManager.deleteVerse(for: savedVerses[indexPath.row])
        }
        savedVerses.removeIndexPaths(at: indexPathToDelete)
        verseCollectionView.performBatchUpdates({
            verseCollectionView.deleteItems(at: indexPathToDelete)
        }) { (true) in
            self.indexPathToDelete.removeAll()
        }
        
        isEditingVerses = !isEditingVerses
        navigationItem.rightBarButtonItem?.title = "Edit"
        self.deleteButtonTopAnchor?.isActive = false
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.deleteButtonTopAnchor = self.deleteButton.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (self.tabBarController?.tabBar.frame.size.height ?? 50))
            self.deleteButtonTopAnchor?.isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
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
        containerView.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        view.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(verseCollectionView)
        view.addSubview(deleteButton)
        verseCollectionView.delegate = self
        verseCollectionView.dataSource = self
        layoutViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didPressEdit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
    }
    
    @objc func didPressEdit(sender: UIBarButtonItem) {
        deleteButtonTopAnchor?.isActive = false
        if isEditingVerses {
            isEditingVerses = !isEditingVerses
            sender.title = "Edit"
            removeDeleteImage()
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.deleteButtonTopAnchor = self.deleteButton.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (self.tabBarController?.tabBar.frame.size.height ?? 50))
                self.deleteButtonTopAnchor?.isActive = true
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            isEditingVerses = !isEditingVerses
            sender.title = "Cancel"
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.deleteButtonTopAnchor = self.deleteButton.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40)
                self.deleteButtonTopAnchor?.isActive = true
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
    var deleteButtonTopAnchor: NSLayoutConstraint?
    
    func layoutViews() {
        containerView.fillContainer(for: self.view)
        verseCollectionView.fillContainer(for: containerView)
        deleteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        deleteButtonTopAnchor = deleteButton.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30)
        deleteButtonTopAnchor?.isActive = true
        let deleteButtonHeight: CGFloat = 30
        deleteButton.heightAnchor.constraint(equalToConstant: deleteButtonHeight).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        deleteButton.layer.cornerRadius = deleteButtonHeight / 2
        deleteButton.layer.masksToBounds = false
        deleteButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        deleteButton.layer.shadowColor = UIColor.black.cgColor
        deleteButton.layer.shadowOpacity = 0.4
        deleteButton.layer.shadowRadius = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.preferredFont(forTextStyle: .subheadline)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = verseCollectionView.cellForItem(at: indexPath) as! VerseCollectionViewCell
        if !isEditingVerses {
            guard let verse = cell.verse else {return}
            savedVerseDelegate?.requestToOpenVerse(for: verse)
        } else {
            if cell.deleteImage.isHidden {
                cell.deleteImage.isHidden = false
                indexPathToDelete.append(indexPath)
            } else {
                cell.deleteImage.isHidden = true
                indexPathToDelete = indexPathToDelete.filter( {$0 != indexPath})
            }
        }
    }
    
}

protocol SavedVerseDelegate: class {
    func requestToOpenVerse(for verse: BibleVerse)
}
