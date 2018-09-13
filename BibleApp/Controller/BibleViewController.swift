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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled), name: .darkModeEnabled, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled), name: .darkModeDisabled, object: nil)
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
    }
    
    func layoutViews() {
        indexList.addSpecificAnchors(topContainer: self.view, leadingContainer: self.view, trailingContainer: nil, bottomContainer: self.view, heightConstant: nil, widthConstant: 25, heightContainer: nil, widthContainer: nil, inset: UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0))

        containerView.addSpecificAnchors(topContainer: self.view, leadingContainer: nil, trailingContainer: self.view, bottomContainer: self.view, heightConstant: nil, widthConstant: nil, heightContainer: nil, widthContainer: nil)
        containerView.leadingAnchor.constraint(equalTo: indexList.trailingAnchor).isActive = true
        
        bibleTableView.fillContainer(for: containerView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentBook(for dict: [Int : [String]], book: String) {
        let controller = BookTableController()
        controller.bookDict = dict
        controller.navigationItem.title = book
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentBookAndScroll(for dict: [Int : [String]], book: String, chapter: Int, verse: Int) {
        let controller = BookTableController()
        controller.bookDict = dict
        controller.navigationItem.title = book
        self.navigationController?.pushViewController(controller, animated: true)
        let indexPath = IndexPath(item: verse - 1, section: chapter - 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            controller.bookTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            controller.bookTableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            let _ = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { timer in
                controller.bookTableView.deselectRow(at: indexPath, animated: true)
            }
        }
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
        let controller = BibleBookDetailViewController()
        if indexPath.section < bible.booksOfOldTestament.count {
            controller.book = bible.booksOfOldTestamentStrings[indexPath.section]
        } else {
            controller.book = bible.booksOfNewTestamentStrings[indexPath.section - bible.booksOfOldTestament.count]
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var book = ""
        if indexPath.section < bible.booksOfOldTestament.count {
            book = bible.booksOfOldTestamentStrings[indexPath.section]
        } else {
            book = bible.booksOfNewTestamentStrings[indexPath.section - bible.booksOfOldTestament.count]
        }
        tableView.deselectRow(at: indexPath, animated: true)
        guard let dict = bible.bookVerseDictionary[book] else {return}
        presentBook(for: dict, book: book)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if indexList.indexState == .scrollingTable {
            guard let firstCell = bibleTableView.visibleCells.first else {return}
            guard let firstBook = firstCell.textLabel?.text else {return}
            if let index = bible.booksOfOldTestamentStrings.index(of: firstBook) {
                indexList.updatePositionOfBookMarker(index: index)
            }
            if let index = bible.booksOfNewTestamentStrings.index(of: firstBook) {
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

