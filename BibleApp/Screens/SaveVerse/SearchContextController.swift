//
//  SearchContextController.swift
//  BibleApp
//
//  Created by Min Kim on 10/22/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SearchContextController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    var searchItems = [String]()
    var filteredItems = [String]()
    var isSearching = false
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Verse"
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearch(searchController.searchBar.text!)
    }
    
    func filterContentForSearch(_ text: String) {
        if text == "" {
            isSearching = false
            tableView.reloadData()
            return
        }
        isSearching = true
        filteredItems = searchItems.filter({$0.lowercased().contains(text.lowercased())})
        filteredItems.insert("Create: \(text)", at: 0)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredItems.count : searchItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = isSearching ? filteredItems[indexPath.row] : searchItems[indexPath.row]
        return cell
    }

}
