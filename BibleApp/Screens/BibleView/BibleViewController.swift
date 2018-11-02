//
//  ViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

final class BibleViewController: UIViewController {
    
    var bible: Bible!
    var selectedBookIndexPath: IndexPath? {
        didSet {
            bibleTableView.beginUpdates()
            bibleTableView.endUpdates()
        }
    }
    weak var bibleCoordinatorDelegate: BibleCoordinatorDelegate?
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        return cv
    }()
    
    let topView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        return cv
    }()
    
    let bibleTableView: BibleTableView = {
        let tv = BibleTableView()
        return tv
    }()
    
    lazy var indexList: IndexTracker = {
        let oldIndexArray = ["Gn", "Ex", "Lv", "Nu", "Dt", "Jos", "Jdg", "Rut", "1Sa", "2Sa", "1Ki", "2Ki", "1Ch", "2Ch", "Ez", "Neh", "Es", "Job", "Ps", "Prv", "Ecc", "Sng", "Is", "Jer", "Lam", "Ez", "Dan", "Hos", "Jol", "Am", "Oba", "Jon", "Mic", "Nah", "Hab", "Zep", "Hag", "Zec", "Mal", "Mt", "Mk", "Lk", "Jn", "Ac", "Ro", "1Co", "2Co", "Gal", "Eph", "Php", "Col", "1Th", "2Th", "1Ti", "2Ti", "Ti", "Ph", "Heb", "Jm", "1Pt", "2Pt", "1Jn", "2Jn", "3Jn", "Jud", "Rv"]
        let il = IndexTracker(frame: .zero, indexList: oldIndexArray, height: view.frame.height - 200)
        il.translatesAutoresizingMaskIntoConstraints = false
        return il
    }()
    
    var dominantHand: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDominantHand()
        setupViews()
        setupDelegates()
    }
    
    func setupDominantHand() {
        dominantHand = UserDefaults.standard.string(forKey: "DominantHand")
        if dominantHand == nil {
            UserDefaults.standard.set(DominantHand.left.rawValue, forKey: "DominantHand")
            dominantHand = DominantHand.left.rawValue
        }
    }
    
    func setupViews() {
        navigationItem.title = "Mt. Zion"
        view.backgroundColor = .white
        view.addSubviewsUsingAutoLayout(topView, containerView)
        containerView.addSubviewsUsingAutoLayout(bibleTableView, indexList)
        bibleTableView.register(BibleTableViewCell.self, forCellReuseIdentifier: "cell")
        bibleTableView.register(ChapterTableViewCell.self, forCellReuseIdentifier: "chapterCell")
        layoutViews()
    }
    
    func setupDelegates() {
        bibleTableView.dataSource = self
        bibleTableView.delegate = self
        indexList.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("rotated")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        updateViewForDominantHand()
    }
    
    func updateViewForDominantHand() {
        let newDominant = UserDefaults.standard.string(forKey: "DominantHand")
        if newDominant != dominantHand {
            dominantHand = newDominant
            guard let indexListLeadingAnchor = indexListLeadingAnchor, let indexListTrailingAnchor = indexListTrailingAnchor, let containerViewLeadingAnchor = bibleTableViewLeadingAnchor, let containerViewTrailingAnchor = bibleTableViewTrailingAnchor else {return}
            NSLayoutConstraint.deactivate([indexListLeadingAnchor, indexListTrailingAnchor, containerViewLeadingAnchor, containerViewTrailingAnchor])
            setLayoutForDominantHand()
        }
    }
    
    var indexListLeadingAnchor: NSLayoutConstraint?
    var indexListTrailingAnchor: NSLayoutConstraint?
    var bibleTableViewLeadingAnchor: NSLayoutConstraint?
    var bibleTableViewTrailingAnchor: NSLayoutConstraint?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BibleViewController: IndexListDelegate {
    func pressedIndex(at index: Int) {
        let numberOfIndexesInBible = 65
        if index < 0 || index > (numberOfIndexesInBible) {
            return
        }
        var generator: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
        let indexPath = IndexPath(row: 0, section: index)
        UIView.animate(withDuration: 0.1) {
            self.bibleTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            if index < 51 {
                generator?.prepare()
                generator?.selectionChanged()
                generator = nil
            }
        }
    }
}

extension BibleViewController: DidSelectChapterCVDelegate {
    func didSelectChapter(for chapter: Int) {
        guard let selectedIndex = selectedBookIndexPath else {return}
        let cell = bibleTableView.cellForRow(at: IndexPath(row: 0, section: selectedIndex.section)) as? BibleTableViewCell
        guard let book = cell?.bibleBook else {return}
        bibleCoordinatorDelegate?.openBibleChapter(book: book, chapter: chapter)
        selectedBookIndexPath = nil
    }
    
}


