//
//  BibleBookDetailViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/25/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class BibleBookDetailViewController: UIViewController {
    
    var book: String! {
        didSet {
            navigationItem.title = book
        }
    }
    
    let containerView: UIView = {
      let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(containerView)
        layoutViews()
    }
    
    func layoutViews() {
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
