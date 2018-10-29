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
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchControllers: SearchController?
    weak var cardPanDelegate: CardPanDelegate?
    
    var cardState: CardState = .compressed {
        didSet {
            if cardState != oldValue {
                print("new state")
                configure(forCardState: cardState)
            }
        }
    }
    
    let cardSearchBar: UISearchBar = {
        let sb = UISearchBar()
        return sb
    }()
    
    lazy var searchTableView: UITableView = {
        let st = UITableView(frame: .zero, style: .plain)
        st.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        st.register(SearchWordTableViewCell.self, forCellReuseIdentifier: "searchCell")
        st.rowHeight = UITableViewAutomaticDimension
        st.keyboardDismissMode = .onDrag
        st.estimatedRowHeight = 100
//        st.isUserInteractionEnabled = false
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
        setupSearchController()
        setupTableView()
        layoutViews()
        addPanGesture()
        configure(forCardState: cardState)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func configure(forCardState cardState: CardState) {
        switch cardState {
        case .compressed:
            searchTableView.panGestureRecognizer.isEnabled = false
            break
        case .expanded:
            searchTableView.panGestureRecognizer.isEnabled = false
            break
        case .fullHeight:
            if searchTableView.contentOffset.y > 0.0 {
                panGestureRecognizer?.isEnabled = false
            } else {
                panGestureRecognizer?.isEnabled = true
            }
            searchTableView.panGestureRecognizer.isEnabled = true
            break
        }
    }
    
    func setupViews() {
        searchControllers = VerseSearchController(bible: Bible(verseDataManager: VersesDataManager()))
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.addSubviewsUsingAutoLayout(cardSearchBar, searchTableView, handleBar)
    }
    
    func setupSearchController() {
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        //        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Verse"
        //        searchController.delegate = self
        //        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Verse", "Word"]
        searchController.searchBar.tintColor = MainColor.redOrange
    }
    
    func setupTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.bounces = false
    }
    
//    @objc func keyboardWillDisappear() {
//        searchController.isActive = false
//        searchTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    var shouldHandleTableGesture = true
    
    func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        panGestureRecognizer = panGesture
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        if !shouldHandleTableGesture {
            return
        }
        let translationPoint = panGesture.translation(in: view.superview)
        let velocity = panGesture.velocity(in: view.superview).y
        
        switch panGesture.state {
        case .began:
            cardPanDelegate?.cardBeganPan(withVelocity: velocity)
        case .changed:
            cardPanDelegate?.cardDidPan(didChangeTranslationPoint: translationPoint, withVelocity: velocity)
        case .ended:
            cardPanDelegate?.cardFinishedPan(didEndTranslationPoint: translationPoint, withVelocity: velocity)
        default:
            return
        }
    }
    
    
    
    
    
}

extension NotesSearchCard: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let panGestureRecognizer = panGestureRecognizer else {
            print("here")
            return }
        
        let contentOffset = scrollView.contentOffset.y
        if contentOffset <= 0.0 &&
            cardState == .fullHeight &&
            panGestureRecognizer.velocity(in: panGestureRecognizer.view?.superview).y != 0.0 {
            shouldHandleTableGesture = true
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
    
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
    
    func layoutHeader(chapter: Int) -> UIView {
        let headerView = SearchHeader()
        headerView.headerLabel.text = searchControllers?.getHeaderLabel()
        return headerView
    }
    
    
    
}

//extension NotesSearchCard: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
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
//
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
////        changeSearchControllerDelegate?.didChangeSearch(for: selectedScope)
//        searchBar.text = ""
//    }
//
//
//
//}

extension NotesSearchCard: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        let velocity = panGestureRecognizer.velocity(in: view.superview)
        searchTableView.panGestureRecognizer.isEnabled = true
        
        if otherGestureRecognizer == searchTableView.panGestureRecognizer {
            switch cardState {
            case .compressed:
                return false
            case .expanded:
                return false
            case .fullHeight:
                if velocity.y > 0.0 {
                    // Panned Down
                    if searchTableView.contentOffset.y > 0.0 {
                        return true
                    }
                    shouldHandleTableGesture = true
                    searchTableView.panGestureRecognizer.isEnabled = false
                    return false
                } else {
                    // Panned Up
                    shouldHandleTableGesture = false
                    return true
                }
            }
        }
        return false
    }
}

protocol CardPanDelegate: class {
    func cardBeganPan(withVelocity: CGFloat)
    func cardDidPan(didChangeTranslationPoint: CGPoint, withVelocity: CGFloat)
    func cardFinishedPan(didEndTranslationPoint: CGPoint, withVelocity: CGFloat)
}
