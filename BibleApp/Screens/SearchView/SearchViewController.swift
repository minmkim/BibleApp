//
//  SearchViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/16/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    weak var changeSearchControllerDelegate: ChangeSearchControllerDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    var searchControllers: SearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupViews()
        setupTableView()
    }
    
    func setupViews() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)], for: .normal)
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SearchWordTableViewCell.self, forCellReuseIdentifier: "searchCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Verse"
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Verse", "Word"]
        searchController.searchBar.tintColor = MainColor.redOrange
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async { [unowned self] in
            self.searchController.isActive = true
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchControllers = searchControllers else {return 0}
        return searchControllers.getNumberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 0.1)
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let text = searchControllers?.getTextLabelForRow(for: indexPath.row)
            cell.textLabel?.text = text
            cell.selectedBackgroundView = backgroundView
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchWordTableViewCell
            guard let controller = searchControllers as? WordSearchController else {return cell}
            cell.bibleVerse = controller.searchedVerses[indexPath.item]
            cell.layoutIfNeeded()
            cell.selectedBackgroundView = backgroundView
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchControllers?.didSelectItem(at: indexPath.row)
        tableView.reloadData()
        let firstIndexPath = IndexPath(row: 0, section: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [unowned self] in
            self.tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = layoutHeader(chapter: section)
        return header
    }
    
    func layoutHeader(chapter: Int) -> UIView {
        let headerView = SearchHeader()
        headerView.headerLabel.text = searchControllers?.getHeaderLabel()
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchController.searchBar.selectedScopeButtonIndex == 1 {
            searchController.searchBar.resignFirstResponder()
            let controller = searchControllers as? WordSearchController
            controller?.observeTableViewToLoadMoreVerses(for: indexPath.row, searchText: searchController.searchBar.text ?? "")
        }
        
    }
}

extension SearchViewController: UpdateSearchBarDelegate {
    func updateSearchBar(_ text: String) {
        searchController.searchBar.text = text
    }
    
    
}

protocol ChangeSearchControllerDelegate: class {
    func didChangeSearch(for index: Int)
}
