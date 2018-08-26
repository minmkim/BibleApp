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
    let oldIndexArray = ["Gn", "Ex", "Lv", "Nu", "Dt", "Jos", "Jdg", "Rut", "1Sa", "2Sa", "1Ki", "2Ki", "1Ch", "2Ch", "Ez", "Neh", "Es", "Job", "Ps", "Prv", "Ecc", "Sng", "Is", "Jer", "Lam", "Ez", "Dan", "Hos", "Jol", "Am", "Jon", "Mic", "Nah", "Hab", "Zep", "Hag", "Zec", "Mal", "Mt", "Mk", "Lk", "Jn", "Ac", "Ro", "1Co", "2Co", "Gal", "Eph", "Php", "Col", "1Th", "2Th", "1Ti", "2Ti", "Ti", "Ph", "Heb", "Jm", "1Pt", "2Pt", "1Jn", "2Jn", "3Jn", "Jud", "Rv"]
    
    
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
        self.navigationController?.navigationBar.tintColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
        view.backgroundColor = .white
        bibleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        bibleTableView.dataSource = self
        bibleTableView.delegate = self
        bibleTableView.separatorStyle = .none
        bibleTableView.showsVerticalScrollIndicator = false
//        bibleTableView.sectionIndexColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
        navigationItem.title = "Mt. Zion"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(containerView)
        view.addSubview(bibleTableView)
        view.addSubview(indexList)
        indexList.delegate = self
        layoutViews()
    }
    
    func layoutViews() {
        indexList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        indexList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        indexList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        indexList.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: indexList.trailingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bibleTableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        bibleTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        bibleTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bibleTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
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
    
    func pressedIndex(at index: Int) {
        if index < 0 || index > (oldIndexArray.count - 1) {
            return
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        let indexPath = IndexPath(row: 0, section: index)
        UIView.animate(withDuration: 0.1) {
            self.bibleTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            if index < 51 {
                generator.impactOccurred()
            }
        }       
    }
}

