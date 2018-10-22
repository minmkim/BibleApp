//
//  SavedVerseViewController.swift
//  BibleApp
//
//  Created by Min Kim on 10/20/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SavedVerseViewController: UIViewController {
    
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
        sv.backgroundColor = .white
        sv.separatorStyle = .none
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.addSubview(savedVerseTableView)
        savedVerseTableView.delegate = self
        savedVerseTableView.dataSource = self
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        layoutViews()
        let rightButton = UIBarButtonItem(title: "test", style: .plain, target: self, action: #selector(test))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    var rowHeight: CGFloat = 100
    
    @objc func test() {
        guard let cell = savedVerseTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? VersesWithoutSectionTableViewCell else {return}
        rowHeight = cell.savedVerseCollectionView.contentSize.height * 2
        savedVerseTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
    }
    
    func layoutViews() {
        containerView.fillContainer(for: view)
        savedVerseTableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        savedVerseTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        savedVerseTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        savedVerseTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
}

extension SavedVerseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch true {
        case indexPath.row == 0:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)
            cell.textLabel?.text = "Saved Verses"
            let customFont = UIFont.systemFont(ofSize: 34, weight: .bold)
            cell.textLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
            return cell
        case indexPath.row == 1:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "noSectionVerse", for: indexPath) as! VersesWithoutSectionTableViewCell
            return cell
        case indexPath.row % 2 == 0:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! SavedVerseHeaderTableViewCell
            cell.headerLabel.text = "Testing Header"
            return cell
        default:
            let cell = savedVerseTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedVerseTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else if indexPath.row == 1 {
            return rowHeight
        } else if indexPath.row % 2 == 0 {
            return 50
        } else {
            return 200
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
