//
//  NotesController.swift
//  BibleApp
//
//  Created by Min Kim on 10/27/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class NotesController: UIViewController {
    
    let containerView: UIView = {
       let cv = UIView()
        return cv
    }()
    
    let noteTextView: UITextView = {
        let nt = UITextView()
        nt.backgroundColor = .black
        nt.textColor = .lightGray
        let customFont = UIFont.systemFont(ofSize: 18, weight: .regular)
        nt.font = UIFontMetrics.default.scaledFont(for: customFont)
        return nt
    }()
    
    var containerBottomAnchor: NSLayoutConstraint?
    var searchCardTopAnchor: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSearchCard()
        layoutViews()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupViews() {
        view.backgroundColor = .black
        view.addSubviewsUsingAutoLayout(containerView)
        containerView.addSubviewsUsingAutoLayout(noteTextView)
    }
    
    func layoutViews() {
        containerView.fillContainer(for: view)
        containerBottomAnchor = containerView.bottomAnchor.constrain(to: view.bottomAnchor)
        containerBottomAnchor?.isActive = true
        
        searchCard?.view.leadingAnchor.constrain(to: containerView.leadingAnchor)
        searchCard?.view.trailingAnchor.constrain(to: containerView.trailingAnchor)
        searchCardTopAnchor = searchCard?.view.topAnchor.constrain(to: containerView.bottomAnchor, with: -cardHandleHeight)
        searchCardTopAnchor?.isActive = true
        searchCard?.view.heightAnchor.constrain(to: 400)
        
        noteTextView.topAnchor.constrain(to: containerView.topAnchor)
        noteTextView.leadingAnchor.constrain(to: containerView.leadingAnchor, with: 8)
        noteTextView.trailingAnchor.constrain(to: containerView.trailingAnchor, with: -8)
        noteTextView.bottomAnchor.constrain(to: (searchCard?.view.bottomAnchor ?? view.bottomAnchor), with: (-cardHandleHeight + 20))
    }
    
    func setupSearchCard() {
        searchCard = NotesSearchCard()
        guard let controller = searchCard?.searchControllers as? VerseSearchController else {return}
        controller.searchVerseDelegate = self
        searchCard?.cardSearchBarDelegate = self
        addChildViewController(searchCard ?? NotesSearchCard())
        view.addSubviewsUsingAutoLayout(searchCard?.view ?? NotesSearchCard().view)
        searchCard?.didMove(toParentViewController: self)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        searchCard?.view.addGestureRecognizer(panGesture)
    }
    
    enum CardState: String {
        case expanding
        case collapsing
        case expanded
        case collapsed
        
        mutating func next() {
            switch self {
            case .expanding:
                self = .expanded
            case .collapsing:
                self = .collapsed
            case .collapsed:
                self = .expanding
            case .expanded:
                self = .collapsing
            }
        }
    }
    
    enum NoteState {
        case noteTaking
        case searching
    }
    
    let cardHandleHeight: CGFloat = 100
    let cardHeight: CGFloat = 300
    var cardState: CardState = .collapsed {
        didSet {
            if cardState != .expanded {
                searchCard?.searchTableView.isUserInteractionEnabled = false
            } else {
                searchCard?.searchTableView.isUserInteractionEnabled = true
            }
        }
    }
    var noteState: NoteState = .noteTaking
    var isKeyboardUp = false
    var keyboardHeight: CGFloat = 355
    
    var runningAnimators = [UIViewPropertyAnimator]() {
        didSet {
            print(runningAnimators.count)
        }
    }
    var animationProgressWhenInterrupted: CGFloat = 0
    var searchCard: NotesSearchCard?
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        if searchCard?.searchTableView.contentOffset.y != 0 {
            searchCard?.searchTableView.isUserInteractionEnabled = true
            searchCard?.searchTableView.isScrollEnabled = true
        } else {
            switch recognizer.state {
            case .began:
                print("began")
                print(recognizer.velocity(in: searchCard?.view).y)
                
                searchCard?.searchTableView.isUserInteractionEnabled = false
                switch cardState {
                case .collapsed:
                    if recognizer.velocity(in: searchCard?.view).y < 0 {
                        searchCard?.view.isUserInteractionEnabled = false
                        startInteractiveTransition(state: cardState, duration: 0)
                    }
                case .expanded:
//                    if isKeyboardUp {
//
//                    }
                    if recognizer.velocity(in: searchCard?.view).y > 0 {
                        searchCard?.view.isUserInteractionEnabled = false
                        startInteractiveTransition(state: cardState, duration: 0)
                    }
                default:
                    return
                }
            case .changed:
                let translation = recognizer.translation(in: self.searchCard?.view)
                var fractionComplete = translation.y / cardHeight
                fractionComplete = cardState == .expanding ? -fractionComplete : fractionComplete
                updateInteractiveTransition(fractionCompleted: fractionComplete)
            case .ended:
                print("ended")
                continueInteractiveTransition()
            default:
                print("here")
            }
        }
        
    }

    @objc func keyboardWillDisappear() {
        isKeyboardUp = false
        self.containerBottomAnchor?.isActive = false
        noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (cardHandleHeight), right: 0)
        UIView.animate(withDuration: 0.3) {
            self.containerBottomAnchor = self.containerView.bottomAnchor.constrain(to: self.view.bottomAnchor)
            self.containerBottomAnchor?.isActive = true
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillAppear(_ notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardHeight = (keyboardFrame.height + 20)
        isKeyboardUp = true
        if cardState != .expanded && cardState != .expanding {
//            animateTransitionIfNeeded(state: cardState, duration: 0.4)
        }
        noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardHeight + cardHandleHeight - 120), right: 0)
        containerBottomAnchor?.isActive = false
        UIView.animate(withDuration: 0.3) {
            self.containerBottomAnchor = self.containerView.bottomAnchor.constrain(to: self.view.bottomAnchor, with: -self.keyboardHeight)
            self.view.layoutIfNeeded()
        }
//        if searchCard?.cardSearchBar.isFirstResponder == true {
//            noteState = .searching
//            animateTransitionIfNeeded(state: cardState, duration: 0.4)
//        } else {
//            noteState = .noteTaking
        
////            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardHeight - cardHandleHeight + 50), right: 0)
//        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                print("starting animation")
                switch state {
                case .collapsed:
                    self.searchCardTopAnchor?.isActive = false
                    self.searchCardTopAnchor = self.searchCard?.view.topAnchor.constrain(to: self.containerView.bottomAnchor, with: -self.cardHeight)
                    self.searchCardTopAnchor?.isActive = true
                    self.cardState.next()
                    self.view.layoutIfNeeded()
                case .expanded:
                    self.searchCardTopAnchor?.isActive = false
                    self.searchCardTopAnchor = self.searchCard?.view.topAnchor.constrain(to: self.containerView.bottomAnchor, with: -(self.cardHandleHeight))
                    self.searchCardTopAnchor?.isActive = true
                    self.cardState.next()
                    self.view.layoutIfNeeded()
                default:
                    return
                }
               
            }
            frameAnimator.startAnimation()
            runningAnimators.append(frameAnimator)
            
            frameAnimator.addCompletion { _ in
                self.searchCard?.view.isUserInteractionEnabled = true
                self.runningAnimators.removeAll()
                self.cardState.next()
            }
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            animateTransitionIfNeeded(state: state, duration: 0.4)
        }
        
        for animator in runningAnimators {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimators {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimators {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    

}

extension NotesController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer else {return false}
        let direction = gesture.velocity(in: view).y
        let y = (searchCard?.view.frame.minY ?? 0)
        
        if (direction < 0) {
            print("3")
            searchCard?.searchTableView.isScrollEnabled = true
            return true
        }

        if ((y == (view.frame.height - cardHeight) && ((searchCard?.searchTableView.contentOffset.y ?? 0) <= 0) && direction > 0)) {
            print("1")
            searchCard?.searchTableView.isScrollEnabled = false
            return false
        } else {
            print("2")
            searchCard?.searchTableView.isScrollEnabled = true
            return true
        }

    }
}

extension NotesController: UITextViewDelegate {
    

}

extension NotesController: CardSearchBarDelegate {
    func didPressSearchBar() {
        if cardState != .expanded || cardState != .expanding {
            animateTransitionIfNeeded(state: cardState, duration: 0.3)
        }
    }
    
    
}

extension NotesController: SearchVerseDelegate {
    func requestToOpenBibleVerse(book: String, chapter: Int, verse: Int) {
        <#code#>
    }
    
    
}
