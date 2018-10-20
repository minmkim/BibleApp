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
    var dataManager: VersesDataManager?
    var isEditingVerses = false
    var indexPathToDelete = [IndexPath]()
    let verseCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(VerseCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 48, right: 0)
        return cv
    }()
    
    let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    lazy var actionBar: SavedVerseActionBar = {
       let ab = SavedVerseActionBar()
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.savedVerseActionBarDelegate = self
        return ab
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedVerses.removeAll()
        dataManager?.loadVerses(completion: { [weak self] (savedVerses) in
            self?.savedVerses = savedVerses
            DispatchQueue.main.async {
                self?.verseCollectionView.reloadData()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isEditingVerses {
            removeDeleteImage()
            indexPathToDelete.removeAll()
            setupEditView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Saved Verses"
        view.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(verseCollectionView)
        view.addSubview(actionBar)
        verseCollectionView.delegate = self
        verseCollectionView.dataSource = self
        layoutViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didPressEdit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
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
        } else {//editing
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
    var actionBarTopAnchor: NSLayoutConstraint?
    
    func layoutViews() {
        containerView.fillContainer(for: self.view)
        verseCollectionView.fillContainer(for: containerView)
        actionBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        actionBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        actionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        actionBarTopAnchor = actionBar.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        actionBarTopAnchor?.isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var didLongPress = false
    
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

extension VerseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedVerses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = verseCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VerseCollectionViewCell
        cell.verse = savedVerses[indexPath.item]
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressCell))
        cell.addGestureRecognizer(longPress)
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

extension VerseViewController: SavedVerseActionBarDelegate {
    func didPressTrash() {
        if !indexPathToDelete.isEmpty {
            indexPathToDelete.forEach { (indexPath) in
                let cell = self.verseCollectionView.cellForItem(at: indexPath) as! VerseCollectionViewCell
                cell.deleteImage.isHidden = true
                dataManager?.deleteVerse(for: savedVerses[indexPath.row])
            }
            savedVerses.removeIndexPaths(at: indexPathToDelete)
            verseCollectionView.performBatchUpdates({
                verseCollectionView.deleteItems(at: indexPathToDelete)
            }) { (true) in
                self.indexPathToDelete.removeAll()
            }
            setupEditView()
        }
    }
    
    func didPressShare() {
        var text = ""
        indexPathToDelete.forEach { (indexPath) in
            let verse = savedVerses[indexPath.item]
            text += "\n\(verse.formattedVerseAndText())\n"
        }
        if text != "" {
            text.removeFirst()
            text.removeLast()
            let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            setupEditView()
        }
    }    
    
}

protocol SavedVerseDelegate: class {
    func requestToOpenVerse(for verse: SavedVerse)
}
