//
//  ViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class BibleViewController: UIViewController {

    var bible: Bible!
    weak var bibleCoordinatorDelegate: BibleCoordinatorDelegate?
    let oldIndexArray = ["Gn", "Ex", "Lv", "Nu", "Dt", "Jos", "Jdg", "Rut", "1Sa", "2Sa", "1Ki", "2Ki", "1Ch", "2Ch", "Ez", "Neh", "Es", "Job", "Ps", "Prv", "Ecc", "Sng", "Is", "Jer", "Lam", "Ez", "Dan", "Hos", "Jol", "Am", "Oba", "Jon", "Mic", "Nah", "Hab", "Zep", "Hag", "Zec", "Mal", "Mt", "Mk", "Lk", "Jn", "Ac", "Ro", "1Co", "2Co", "Gal", "Eph", "Php", "Col", "1Th", "2Th", "1Ti", "2Ti", "Ti", "Ph", "Heb", "Jm", "1Pt", "2Pt", "1Jn", "2Jn", "3Jn", "Jud", "Rv"]
    
    let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let bibleTableView: UITableView = {
       let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var indexList: IndexTracker = {
        let il = IndexTracker(frame: .zero, indexList: oldIndexArray, height: view.frame.height - 200)
        il.translatesAutoresizingMaskIntoConstraints = false
        return il
    }()
    
    var dominantHand: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dominantHand = UserDefaults.standard.string(forKey: "DominantHand")
        if dominantHand == nil {
            UserDefaults.standard.set("Left", forKey: "DominantHand")
            dominantHand = "Left"
        }
        view.addSubview(containerView)
        view.addSubview(bibleTableView)
        view.addSubview(indexList)
        layoutViews()
        self.navigationController?.view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        tabBarController?.tabBar.barTintColor = .white
        tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
        bibleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        bibleTableView.dataSource = self
        bibleTableView.delegate = self
        bibleTableView.separatorStyle = .none
        bibleTableView.showsVerticalScrollIndicator = false
        navigationItem.title = "Mt. Zion"
        indexList.delegate = self
    }
    
    var isDarkMode = false
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("rotated")
//        indexList.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        let newDominant = UserDefaults.standard.string(forKey: "DominantHand")
        if newDominant != dominantHand {
            dominantHand = newDominant
            
            indexListLeadingAnchor?.isActive = false
            indexListTrailingAnchor?.isActive = false
            containerViewLeadingAnchor?.isActive = false
            containerViewTrailingAnchor?.isActive = false
            indexListWidthAnchor?.isActive = false
            
            UIView.animate(withDuration: 0.01, animations: {
                if self.dominantHand == "Left" {
                    self.indexListLeadingAnchor = self.indexList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
                    self.indexListLeadingAnchor?.isActive = true
                    self.indexListWidthAnchor?.isActive = true
                    
                    self.containerViewTrailingAnchor = self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
                    self.containerViewTrailingAnchor?.isActive = true
                    self.indexListWidthAnchor = self.indexList.widthAnchor.constraint(equalToConstant: 25)
                    self.view.layoutIfNeeded()
                } else {
                    self.indexListTrailingAnchor = self.indexList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
                    self.indexListTrailingAnchor?.isActive = true
                    self.indexListWidthAnchor?.isActive = true
                    
                    self.containerViewLeadingAnchor = self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
                    self.containerViewLeadingAnchor?.isActive = true
                    self.indexListWidthAnchor = self.indexList.widthAnchor.constraint(equalToConstant: 25)
                    self.view.layoutIfNeeded()
                }
            }) { (true) in
                if self.dominantHand == "Left" {
                    self.containerViewLeadingAnchor = self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25)
                    self.containerViewLeadingAnchor?.isActive = true
                    self.view.layoutIfNeeded()
                } else {
                    self.containerViewTrailingAnchor = self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25)
                    self.containerViewTrailingAnchor?.isActive = true
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    var indexListLeadingAnchor: NSLayoutConstraint?
    var indexListTrailingAnchor: NSLayoutConstraint?
    var indexListWidthAnchor: NSLayoutConstraint?
    var containerViewLeadingAnchor: NSLayoutConstraint?
    var containerViewTrailingAnchor: NSLayoutConstraint?
    
    
    func layoutViews() {
        indexListWidthAnchor = indexList.widthAnchor.constraint(equalToConstant: 25)
        indexListWidthAnchor?.isActive = true
        if dominantHand == "Left" {
            indexList.addSpecificAnchors(topContainer: self.view, leadingContainer: nil, trailingContainer: nil, bottomContainer: self.view, heightConstant: nil, widthConstant: nil, heightContainer: nil, widthContainer: nil, inset: UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0))
            indexListLeadingAnchor = indexList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            indexListLeadingAnchor?.isActive = true
            containerView.addSpecificAnchors(topContainer: self.view, leadingContainer: nil, trailingContainer: self.view, bottomContainer: self.view, heightConstant: nil, widthConstant: nil, heightContainer: nil, widthContainer: nil)
            containerViewLeadingAnchor = containerView.leadingAnchor.constraint(equalTo: indexList.trailingAnchor)
            containerViewLeadingAnchor?.isActive = true
            
            bibleTableView.fillContainer(for: containerView)
        } else {
            containerView.addSpecificAnchors(topContainer: self.view, leadingContainer: self.view, trailingContainer: nil, bottomContainer: self.view, heightConstant: nil, widthConstant: nil, heightContainer: nil, widthContainer: nil)
            indexList.addSpecificAnchors(topContainer: self.view, leadingContainer: nil, trailingContainer: nil, bottomContainer: self.view, heightConstant: nil, widthConstant: nil, heightContainer: nil, widthContainer: nil, inset: UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0))
            indexListTrailingAnchor = indexList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            indexListTrailingAnchor?.isActive = true
            
            containerViewTrailingAnchor = containerView.trailingAnchor.constraint(equalTo: indexList.leadingAnchor)
            containerViewTrailingAnchor?.isActive = true
            
            bibleTableView.fillContainer(for: containerView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BibleViewController: UITableViewDelegate, UITableViewDataSource, IndexListDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (bible.booksOfOldTestament.count + bible.booksOfNewTestament.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section < bible.booksOfOldTestament.count {
            cell.textLabel?.text = bible.booksOfOldTestamentStrings[indexPath.section]
        } else {
            cell.textLabel?.text = bible.booksOfNewTestamentStrings[indexPath.section - bible.booksOfOldTestament.count]
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 0.1)
        cell.selectedBackgroundView = backgroundView
        cell.accessoryType = .detailButton
        cell.tintColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
        if isDarkMode {
            let theme = Theme.dark
            cell.backgroundColor = theme.backgroundColor
            cell.textLabel?.textColor = theme.textColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        bibleCoordinatorDelegate?.openBibleWebsite(for: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        bibleCoordinatorDelegate?.openBibleBook(for: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if indexList.indexState == .scrollingTable {
            guard let firstCell = bibleTableView.visibleCells.first else {return}
            guard let firstBook = firstCell.textLabel?.text else {return}
            if let index = bible.booksOfOldTestament.index(of: firstBook) {
                indexList.updatePositionOfBookMarker(index: index)
            }
            if let index = bible.booksOfNewTestament.index(of: firstBook) {
                let newIndex = index + 39
                indexList.updatePositionOfBookMarker(index: newIndex)
            }
        }
        
    }
    
    func pressedIndex(at index: Int) {
        if index < 0 || index > (oldIndexArray.count - 1) {
            return
        }
        let generator = UISelectionFeedbackGenerator()
        let indexPath = IndexPath(row: 0, section: index)
        UIView.animate(withDuration: 0.1) {
            self.bibleTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            if index < 51 {
                generator.prepare()
                generator.selectionChanged()
            }
        }       
    }
}

protocol BibleCoordinatorDelegate: class {
    func openBibleBook(for indexPath: IndexPath)
    func openBibleWebsite(for indexPath: IndexPath)
}

