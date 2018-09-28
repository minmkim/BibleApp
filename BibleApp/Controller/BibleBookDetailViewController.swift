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
    
    let dictOfBookWikiYouTube = ["Genesis": ["Book_of_Genesis", "KOUV7mWDI34"],
                                 "Exodus": ["Book_of_Exodus", "z7FEtFgkcuw"],
                                 "Leviticus": ["Book_of_Leviticus", "FekWUZzE"],
                                 "Numbers": ["Book_of_Numbers", "tp5MIrMZFqo"],
                                 "Deuteronomy": ["Book_of_Deuteronomy", "q5QEH9bH8AU"],
                                 "Joshua": ["Book_of_Joshua", "JqOqJlFF_eU"],
                                 "Judges": ["Book_of_Judges", "kOYy8iCfIJ4"],
                                 "Ruth": ["Book_of_Ruth", "0h1eoBeR4Jk"],
                                 "1 Samuel": ["Book_of_Samuel", "QJOju5Dw0V0"],
                                 "2 Samuel": ["Book_of_Samuel", "YvoWDXNDJgs"],
                                 "1 Kings": ["Book_of_Kings", "bVFW3wbi9pk"],
                                 "2 Kings": ["Book_of_Kings", "bVFW3wbi9pk"],
                                 "1 Chronicles": ["Book_of_Chronicles", "HR7xaHv3Ias"],
                                 "2 Chronicles": ["Book_of_Chronicles", "HR7xaHv3Ias"],
                                 "Ezra": ["Book_of_Ezra", "MkETkRv9tG8"],
                                 "Nehemiah": ["Book_of_Nehemiah", "MkETkRv9tG8"],
                                 "Esther": ["Book_of_Esther", "JydNSlufRIs"],
                                 "Job": ["Book_of_Job", "xQwnH8th_fs"],
                                 "Psalms": ["Psalms", "j9phNEaPrv8"],
                                 "Proverbs": ["Book_of_Proverbs", "AzmYV8GNAIM"],
                                 "Ecclesiastes": ["Ecclesiastes", "lrsQ1tc-2wk"],
                                 "Song of Songs": ["Song_of_Songs", "4KC7xE4fgOw"],
                                 "Isaiah": ["Book_of_Isaiah", "d0A6Uchb1F8"],
                                 "Jeremiah": ["Book_of_Jeremiah", "RSK36cHbrk0"],
                                 "Lamentations": ["Book_of_Lamentations", "p8GDFPdaQZQ"],
                                 "Ezekiel": ["Book_of_Ezekiel", "R-CIPu1nko8"],
                                 "Daniel": ["Book_of_Daniel", "9cSC9uobtPM"],
                                 "Hosea": ["Book_of_Hosea", "kE6SZ1ogOVU"],
                                 "Joel": ["Book_of_Joel", "zQLazbgz90c"],
                                 "Amos": ["Book_of_Amos", "mGgWaPGpGz4"],
                                 "Obadiah": ["Book_of_Obadiah", "i4ogCrEoG5s"],
                                 "Jonah": ["Book_of_Jonah", "dLIabZc0O4c"],
                                 "Micah": ["Book_of_Micah", "MFEUEcylwLc"],
                                 "Nahum": ["Book_of_Nahum", "Y30DanA5EhU"],
                                 "Habakkuk": ["Book_of_Habakkuk", "OPMaRqGJPUU"],
                                 "Zephaniah": ["Book_of_Zephaniah", "oFZknKPNvz8"],
                                 "Haggai": ["Book_of_Haggai", "juPvv_xcX-U"],
                                 "Zechariah": ["Book_of_Zechariah", "_106IfO6Kc0"],
                                 "Malachi": ["Book_of_Malachi", "HPGShWZ4Jvk"],
                                 "Matthew": ["Gospel_of_Matthew", "3Dv4-n6OYGI"],
                                 "Mark": ["Gospel_of_Mark", "HGHqu9-DtXk"],
                                 "Luke": ["Gospel_of_Luke", "XIb_dCIxzr0"],
                                 "John": ["Gospel_of_John", "G-2e9mMf7E8"],
                                 "Acts": ["Acts_of_the_Apostles", "CGbNw855ksw"],
                                 "Romans": ["Epistle_to_the_Romans", "ej_6dVdJSIU"],
                                 "1 Corinthians": ["First_Epistle_to_the_Corinthians", "yiHf8klCCc4"],
                                 "2 Corinthians": ["Second_Epistle_to_the_Corinthians", "3lfPK2vfC54"],
                                 "Galatians": ["Epistle_to_the_Galatians", "vmx4UjRFp0M"],
                                 "Ephesians": ["Epistle_to_the_Ephesians", "Y71r-T98E2Q"],
                                 "Philippians": ["Epistle_to_the_Philippians", "oE9qqW1-BkU"],
                                 "Colossians": ["Epistle_to_the_Colossians", "pXTXlDxQsvc"],
                                 "1 Thessalonians": ["First_Epistle_to_the_Thessalonians", "No7Nq6IX23c"],
                                 "2 Thessalonians": ["Second_Epistle_to_the_Thessalonians", "kbPBDKOn1cc"],
                                 "1 Timothy": ["First_Epistle_to_Timothy", "7RoqnGcEjcs"],
                                 "2 Timothy": ["Second_Epistle_to_Timothy", "urlvnxCaL00"],
                                 "Titus": ["Titus", "PUEYCVXJM3k"],
                                 "Philemon": ["Epistle_to_Philemon", "aW9Q3Jt6Yvk"],
                                 "Hebrews": ["Epistle_to_the_Hebrews", "1fNWTZZwgbs"],
                                 "James": ["Epistle_of_James", "qn-hLHWwRYY"],
                                 "1 Peter": ["First_Epistle_of_Peter", "WhP7AZQlzCg"],
                                 "2 Peter": ["Second_Epistle_of_Peter", "wWLv_ITyKYc"],
                                 "1 John": ["First_Epistle_of_John", "l3QkE6nKylM"],
                                 "2 John": ["Second_Epistle_of_John", "l3QkE6nKylM"],
                                 "3 John": ["Third_Epistle_of_John", "l3QkE6nKylM"],
                                 "Jude": ["Epistle_of_Jude", "6UoCmakZmys"],
                                 "Revelation": ["Book_of_Revelation", "5nvVVcYD-0w"]]
    
    func returnBookNameForWikipedia() -> String {
        guard let book = self.book else {return ""}
        guard let bookDict = dictOfBookWikiYouTube[book] else {return ""}
        return bookDict[0]
    }
    
    let containerView: UIView = {
      let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let webKitView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    var spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(webKitView)
        view.addSubview(spinner)
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
        guard let bookDict = dictOfBookWikiYouTube[book] else {return ""}
        return bookDict[1]
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.webKitView.isHidden = false
        }
    }
    
    func layoutViews() {
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        spinner.fillContainer(for: containerView)
        
        webKitView.fillContainer(for: containerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
