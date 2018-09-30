//
//  SearchViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/16/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchViewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearchController()
        searchViewModel.searchWordDelegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SearchWordTableViewCell.self, forCellReuseIdentifier: "searchCell")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)], for: .normal)
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
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    
    
    func searchBarIsEmpty() {
        searchViewModel.searchParameter = (searchController.searchBar.text?.isEmpty ?? true) ? .empty : .book
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
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
        return searchViewModel.returnNumberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchViewModel.searchState == .verse {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let text = searchViewModel.returnTextLabel(for: indexPath.row)
            cell.textLabel?.text = text
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 0.1)
            cell.selectedBackgroundView = backgroundView
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchWordTableViewCell
            cell.bibleVerse = searchViewModel.searchedVerses[indexPath.item]
            cell.layoutIfNeeded()
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 0.1)
            cell.selectedBackgroundView = backgroundView
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let firstIndexPath = IndexPath(row: 0, section: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
        }
        if searchViewModel.searchParameter == .verse {
            let _ = searchViewModel.didSelectItem(at: indexPath.row, number: indexPath.row)
            searchController.searchBar.text? = ""
        } else {
            guard let cell = tableView.cellForRow(at: indexPath) else {return}
            if let text = cell.textLabel?.text {
                let number = Int(text)
                let newString = searchViewModel.didSelectItem(at: indexPath.row, number: number)
                searchController.searchBar.text? = newString
                return
            }
            let _ = searchViewModel.didSelectItem(at: indexPath.row, number: nil)
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
        headerView.headerLabel.text = searchViewModel.returnHeaderLabel()
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchController.searchBar.selectedScopeButtonIndex == 1 {
            searchViewModel.observeTableViewToLoadMoreVerses(for: indexPath.row, text: searchController.searchBar.text ?? "")
        }
        
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        searchBarIsEmpty()
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            filterContentForSearchText(searchController.searchBar.text!)
            switch searchViewModel.searchParameter {
            case .empty:
                searchController.searchBar.keyboardType = .default
            case .book:
                searchController.searchBar.keyboardType = .default
            default:
                searchController.searchBar.keyboardType = .numbersAndPunctuation
            }
            searchController.searchBar.reloadInputViews()
        }
        
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchViewModel.filterContentForSearchText(searchText)
        tableView.reloadData()
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else {return}
        let array = searchViewModel.searchPressed(for: text)
        if array.count == 0 {
            searchController.searchBar.becomeFirstResponder()
            return
        } else {
            tableView.reloadData()
        }
        
//        searchController.searchBar.text = ""
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 { //verse
            searchViewModel.searchState = .verse
            searchController.searchBar.text = ""
            tableView.reloadData()
        } else { //word
            searchViewModel.searchState = .word
            searchController.searchBar.text = ""
            tableView.reloadData()
        }
    }
    
}

extension SearchViewController: SearchWordDelegate {
    func didFinishLoadingMoreVerses(for indexPaths: [IndexPath]) {
        print(tableView.numberOfRows(inSection: 0))
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPaths, with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func didFinishSearching() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
}
