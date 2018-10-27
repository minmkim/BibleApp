//
//  SearchViewController + SearchDelegate.swift
//  BibleApp
//
//  Created by Min Kim on 10/21/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        searchController.searchBar.reloadInputViews()
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            guard let controller = searchControllers as? VerseSearchController else {return}
            switch controller.searchState {
            case .empty, .searchingBook:
                searchController.searchBar.keyboardType = .default
            case .searchingChapter, .searchingVerse:
                searchController.searchBar.keyboardType = .numbersAndPunctuation
            }
        }
        
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchControllers?.filterContentForSearchText(searchText)
        tableView.reloadData()
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else {return}
        searchControllers?.didPressSearch(for: text)
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        changeSearchControllerDelegate?.didChangeSearch(for: selectedScope)
        searchBar.text = ""
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
