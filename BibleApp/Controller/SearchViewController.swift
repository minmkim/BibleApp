//
//  SearchViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/16/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchViewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearchController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)], for: .normal)
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Verse"
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchBarIsEmpty()
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
    
    func searchBarIsEmpty() {
        searchViewModel.searchParameter = (searchController.searchBar.text?.isEmpty ?? true) ? .empty : .book
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchViewModel.filterContentForSearchText(searchText)
        tableView.reloadData()
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.becomeFirstResponder()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let text = searchViewModel.returnTextLabel(for: indexPath.row)
        cell.textLabel?.text = text
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 0.1)
        cell.selectedBackgroundView = backgroundView
        return cell
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
            let number = Int((cell.textLabel?.text)!)
            let text = searchViewModel.didSelectItem(at: indexPath.row, number: number)
            searchController.searchBar.text? = text
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
        let headerView = UIView()
        headerView.isOpaque = false
        headerView.backgroundColor = .white
        headerView.alpha = 1
        let headerLabel = UILabel()
        headerView.addSubview(headerLabel)
        headerLabel.text = searchViewModel.returnHeaderLabel()
        headerLabel.font = .preferredFont(forTextStyle: .headline)
        headerLabel.adjustsFontForContentSizeCategory = true
        headerLabel.textColor = .black
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        return headerView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else {return}
        let array = searchViewModel.searchPressed(for: text)
        if array.count == 0 {
            searchController.searchBar.becomeFirstResponder()
            return
        }
        searchController.searchBar.text = ""
        searchController.searchBar.resignFirstResponder()
    }
   
}
