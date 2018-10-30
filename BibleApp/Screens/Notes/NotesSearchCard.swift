//
//  NotesSearchCard.swift
//  BibleApp
//
//  Created by Min Kim on 10/27/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

enum CardState {
    case expanded
    case fullHeight
    case compressed
}

class NotesSearchCard: UIViewController {
    
//    let searchController = UISearchController(searchResultsController: nil)
    var searchControllers: SearchController?
    weak var cardSearchBarDelegate: CardSearchBarDelegate?
//
    lazy var cardSearchBar: UISearchBar = {
        var sb = UISearchBar()
        sb.delegate = self
        return sb
    }()
    
    lazy var searchTableView: UITableView = {
        let st = UITableView(frame: .zero, style: .plain)
        st.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        st.register(SearchWordTableViewCell.self, forCellReuseIdentifier: "searchCell")
        st.rowHeight = UITableViewAutomaticDimension
//        st.keyboardDismissMode = .onDrag
        st.estimatedRowHeight = 100
        return st
    }()
    
    let handleBar: UIView = {
       let hb = UIView()
        hb.backgroundColor = .lightGray
        hb.layer.masksToBounds = true
        hb.layer.cornerRadius = 2
        hb.isUserInteractionEnabled = false
        return hb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        setupSearchController()
        setupTableView()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func setupViews() {
        let controller = VerseSearchController(bible: Bible(verseDataManager: VersesDataManager()))
        searchControllers = controller
        controller.updateSearchBarDelegate = self
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.addSubviewsUsingAutoLayout(cardSearchBar, searchTableView, handleBar)
    }
    
    func setupSearchController() {
//        cardSearchBar = searchController.searchBar
//        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Verse"
//        searchController.delegate = self
//        searchController.searchBar.delegate = self
        cardSearchBar.scopeButtonTitles = ["Verse", "Word"]
        cardSearchBar.tintColor = MainColor.redOrange
    }
    
    func setupTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.bounces = false
    }
}

extension NotesSearchCard: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchControllers?.getNumberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchControllers?.getTextLabelForRow(for: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = layoutHeader(chapter: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchControllers?.didSelectItem(at: indexPath.row)
    }
    
    func layoutHeader(chapter: Int) -> UIView {
        let headerView = SearchHeader()
        headerView.headerLabel.text = searchControllers?.getHeaderLabel()
        return headerView
    }
    
}

extension NotesSearchCard: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchControllers?.filterContentForSearchText(searchText)
        searchTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("im here")
        cardSearchBarDelegate?.didPressSearchBar()
    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
//        searchController.searchBar.reloadInputViews()
//        if searchController.searchBar.selectedScopeButtonIndex == 0 {
//            guard let controller = searchControllers as? VerseSearchController else {return}
//            switch controller.searchState {
//            case .empty, .searchingBook:
//                searchController.searchBar.keyboardType = .default
//            case .searchingChapter, .searchingVerse:
//                searchController.searchBar.keyboardType = .numbersAndPunctuation
//            }
//        }
//
//    }
//
//    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//        searchControllers?.filterContentForSearchText(searchText)
//
//        searchTableView.reloadData()
//    }
//
//    func presentSearchController(_ searchController: UISearchController) {
//        searchTableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
//        if searchTableView.visibleCells.first != nil {
//            searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
//        }
//        self.searchController.searchBar.becomeFirstResponder()
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchController.searchBar.text else {return}
//        searchControllers?.didPressSearch(for: text)
//        searchController.searchBar.resignFirstResponder()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        DispatchQueue.main.async {
//            self.searchController.searchBar.resignFirstResponder()
//        }
//
//    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        changeSearchControllerDelegate?.didChangeSearch(for: selectedScope)
        cardSearchBar.text = ""
    }



}

extension NotesSearchCard: UpdateSearchBarDelegate {
    func updateSearchBar(_ text: String) {
        cardSearchBar.text = text
        searchTableView.reloadData()
    }
    
    
}

protocol CardSearchBarDelegate: class {
    func didPressSearchBar()
}
