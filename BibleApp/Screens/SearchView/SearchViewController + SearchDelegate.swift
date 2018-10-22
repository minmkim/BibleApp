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
