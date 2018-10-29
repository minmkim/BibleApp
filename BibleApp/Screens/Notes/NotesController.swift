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
        nt.isUserInteractionEnabled = false
        return nt
    }()
    
    var containerBottomAnchor: NSLayoutConstraint?
    var searchCardTopAnchor: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSearchCard()
        layoutViews()
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupViews() {
        view.backgroundColor = .black
        view.addSubviewsUsingAutoLayout(containerView)
        containerView.addSubviewsUsingAutoLayout(noteTextView)
    }
    
    func layoutViews() {
        containerView.fillContainer(for: view)
        containerBottomAnchor = containerView.bottomAnchor.constrain(to: view.safeAreaLayoutGuide.bottomAnchor)
        containerBottomAnchor?.isActive = true
        
        searchCard?.view.leadingAnchor.constrain(to: containerView.leadingAnchor)
        searchCard?.view.trailingAnchor.constrain(to: containerView.trailingAnchor)
        searchCardTopAnchor = searchCard?.view.topAnchor.constrain(to: containerView.bottomAnchor, with: -cardHandleHeight)
        searchCardTopAnchor?.isActive = true
        searchCard?.view.heightAnchor.constrain(to: cardHeight)
        
        noteTextView.topAnchor.constrain(to: containerView.topAnchor)
        noteTextView.leadingAnchor.constrain(to: containerView.leadingAnchor, with: 8)
        noteTextView.trailingAnchor.constrain(to: containerView.trailingAnchor, with: -8)
        noteTextView.bottomAnchor.constrain(to: (searchCard?.view.bottomAnchor ?? view.bottomAnchor), with: (-cardHandleHeight + 20))
    }
    
    func setupSearchCard() {
        searchCard = NotesSearchCard()
        addChildViewController(searchCard ?? NotesSearchCard())
        view.addSubviewsUsingAutoLayout(searchCard?.view ?? NotesSearchCard().view)
        searchCard?.didMove(toParentViewController: self)
        searchCard?.cardPanDelegate = self
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        panGesture.delegate = self
//        searchCard?.view.addGestureRecognizer(panGesture)
    }
    
    enum CardState: String {
        case expandingFull
        case expandingHalf
        case collapsing
    }
    
    enum NoteState {
        case noteTaking
        case searching
    }
    
    let cardHandleHeight: CGFloat = 120
    let cardHeight: CGFloat = 700
    var cardState: CardState = .collapsing
    var noteState: NoteState = .noteTaking
    var isKeyboardUp = false
    var keyboardHeight: CGFloat = 355
    
    var runningAnimators = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    var searchCard: NotesSearchCard?
    
//    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
////        if searchCard?.searchTableView.contentOffset.y != 0 {
////            return
////        }
//        switch recognizer.state {
//        case .began:
//            switch cardState {
//            case .expanding:
//                if recognizer.velocity(in: searchCard?.view).y < 0 {
//                    startInteractiveTransition(state: cardState, duration: 0)
//                }
//            case .collapsing:
//                if recognizer.velocity(in: searchCard?.view).y > 0 {
//                    startInteractiveTransition(state: cardState, duration: 0)
//                }
//            }
//        case .changed:
//            let translation = recognizer.translation(in: self.searchCard?.view)
//            var fractionComplete = translation.y / cardHeight
//            fractionComplete = cardState == .expanding ? -fractionComplete : fractionComplete
//            updateInteractiveTransition(fractionCompleted: fractionComplete)
//        case .ended:
//            continueInteractiveTransition()
//        default:
//            return
//        }
//    }
//
//    @objc func keyboardWillDisappear() {
//        isKeyboardUp = false
//    }
//
//    @objc func keyboardWillAppear(_ notification: Notification) {
//        let userInfo = notification.userInfo ?? [:]
//        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
////        keyboardHeight = (keyboardFrame.height + 20)
//        isKeyboardUp = true
//        if searchCard?.searchController.searchBar.isFirstResponder == true {
//            noteState = .searching
//            animateTransitionIfNeeded(state: .expanding, duration: 0.4)
//        } else {
//            noteState = .noteTaking
//            containerBottomAnchor?.isActive = false
//            UIView.animate(withDuration: 0.3) {
////                self.searchCard?.view.frame.origin.y = (self.view.frame.height - self.keyboardHeight - self.cardHandleHeight + 8)
//                self.containerBottomAnchor = self.containerView.bottomAnchor.constrain(to: self.view.safeAreaLayoutGuide.bottomAnchor, with: -self.keyboardHeight)
//                self.view.layoutIfNeeded()
//            }
////            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardHeight - cardHandleHeight + 50), right: 0)
//        }
//    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                print("starting animation")
                switch state {
                case .expandingFull:
                    self.searchCardTopAnchor?.isActive = false
                    self.searchCardTopAnchor = self.searchCard?.view.topAnchor.constrain(to: self.containerView.bottomAnchor, with: -self.cardHeight)
                    self.searchCardTopAnchor?.isActive = true
                    
                    self.view.layoutIfNeeded()
                case .expandingHalf:
                        self.searchCardTopAnchor?.isActive = false
                        self.searchCardTopAnchor = self.searchCard?.view.topAnchor.constrain(to: self.containerView.bottomAnchor, with: -400)
                        self.searchCardTopAnchor?.isActive = true
                       
                        self.view.layoutIfNeeded()
                case .collapsing:
                    self.searchCardTopAnchor?.isActive = false
                    self.searchCardTopAnchor = self.searchCard?.view.topAnchor.constrain(to: self.containerView.bottomAnchor, with: -(self.cardHandleHeight))
                    self.searchCardTopAnchor?.isActive = true
                    
                    self.view.layoutIfNeeded()
                }
            }
            frameAnimator.startAnimation()
            runningAnimators.append(frameAnimator)
            
            frameAnimator.addCompletion { _ in
                self.runningAnimators.removeAll()
                switch state {
                case .expandingFull:
                    self.cardState = .expandingFull
                    self.searchCard?.cardState = .fullHeight
                case .expandingHalf:
                    self.cardState = .expandingHalf
                     self.searchCard?.cardState = .expanded
                case .collapsing:
                    self.cardState = .collapsing
                    self.searchCard?.cardState = .compressed
                }
            }
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            animateTransitionIfNeeded(state: state, duration: 0.8)
        }
        
        for animator in runningAnimators {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        print("continuing animation")
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
//
//extension NotesController: UIGestureRecognizerDelegate {
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer else {return false}
//        let direction = gesture.velocity(in: view).y
//        let y = (searchCard?.view.frame.minY ?? 0)
//
//        if (y == (view.frame.height - cardHeight) && searchCard?.searchTableView.contentOffset.y == 0 && direction > 0) || (y == view.frame.height - cardHandleHeight) {
//            searchCard?.searchTableView.isScrollEnabled = false
//            return false
//        } else {
//            searchCard?.searchTableView.isScrollEnabled = true
//            return true
//        }
//
//    }
//}

extension NotesController: UITextViewDelegate {
    

}

extension NotesController: CardPanDelegate {
    func cardBeganPan(withVelocity: CGFloat) {
        searchCard?.view.isUserInteractionEnabled = false
        print(withVelocity)
        if (searchCard?.cardState == .compressed && withVelocity < -1000) || (searchCard?.cardState == .expanded && withVelocity < 0) {
            startInteractiveTransition(state: .expandingFull, duration: 0.8)
            cardState = .expandingFull
        } else if searchCard?.cardState == .compressed && withVelocity < 0 {
            startInteractiveTransition(state: .expandingHalf, duration: 0.8)
            cardState = .expandingHalf
        } else if withVelocity > 0 {
            startInteractiveTransition(state: .collapsing, duration: 0.8)
            cardState = .collapsing
        }
    }
    
    
    func cardDidPan(didChangeTranslationPoint: CGPoint, withVelocity: CGFloat) {
        searchCard?.view.isUserInteractionEnabled = false
        if cardState == .expandingHalf || cardState == .expandingFull {
            var fractionComplete = didChangeTranslationPoint.y / (cardHeight/2)
            fractionComplete = cardState == .collapsing ? fractionComplete : -fractionComplete
            print(fractionComplete)
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        } else {
            var fractionComplete = didChangeTranslationPoint.y / (cardHeight)
            fractionComplete = cardState == .collapsing ? fractionComplete : -fractionComplete
            print(fractionComplete)
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        }
        
    }
    
    func cardFinishedPan(didEndTranslationPoint: CGPoint, withVelocity: CGFloat) {
        searchCard?.view.isUserInteractionEnabled = true
        continueInteractiveTransition()
    }
    
    
}
