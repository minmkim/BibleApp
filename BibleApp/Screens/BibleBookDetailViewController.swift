//
//  BibleBookDetailViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/25/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit
import WebKit

class BibleBookDetailViewController: UIViewController, WKNavigationDelegate {
    
    var book: String! {
        didSet {
            navigationItem.title = book
            loadWiki()
        }
    }
    
    func loadWiki() {
        let search = returnBookNameForWikipedia()
        let url = URL(string: "https://en.wikipedia.org/wiki/\(search)")!
        webKitView.load(URLRequest(url: url))
    }
    
    func returnBookNameForWikipedia() -> String {
        guard let book = self.book else {return ""}
        guard let bookDict = Constants.dictOfBookWikiYouTube[book] else {return ""}
        return bookDict[0]
    }
    
    let containerView: UIView = {
      let cv = UIView()
        cv.backgroundColor = .white
        return cv
    }()
    
    let webKitView: WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    var spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return spin
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubviewsUsingAutoLayout(containerView, webKitView, spinner)
        webKitView.navigationDelegate = self
        layoutViews()
        spinner.startAnimating()
        webKitView.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Video", style: .plain, target: self, action: #selector(didPressVideo))
    }
    
    @objc func didPressVideo(sender: UIBarButtonItem) {
        if sender.title == "Video" {
            sender.title = "Wiki"
            spinner.startAnimating()
            webKitView.isHidden = true
            loadYoutube()
        } else {
            sender.title = "Video"
            webKitView.isHidden = true
            spinner.startAnimating()
            loadWiki()
        }
    }
    
    func loadYoutube() {
        let embedCode = returnEmbedCodeForYouTube()
        let url = URL(string: "https://www.youtube.com/embed/\(embedCode)")!
        webKitView.load(URLRequest(url: url))
    }
    
    func returnEmbedCodeForYouTube() -> String {
        guard let book = self.book else {return ""}
        guard let bookDict = Constants.dictOfBookWikiYouTube[book] else {return ""}
        return bookDict[1]
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.webKitView.isHidden = false
        }
    }
    
    func layoutViews() {
        containerView.topAnchor.constrain(to: view.safeAreaLayoutGuide.topAnchor)
        containerView.leadingAnchor.constrain(to: view.safeAreaLayoutGuide.leadingAnchor)
        containerView.trailingAnchor.constrain(to: view.safeAreaLayoutGuide.trailingAnchor)
        containerView.bottomAnchor.constrain(to: view.bottomAnchor)
        
        spinner.fillContainer(for: containerView)
        webKitView.fillContainer(for: containerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


