//
//  VerseSearchControllerTest.swift
//  BibleAppTests
//
//  Created by Min Kim on 10/31/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import XCTest
@testable import BibleApp

class VerseSearchControllerTest: XCTestCase {
    
    var controller: VerseSearchController!
    var testCase: String?

    override func setUp() {
        controller = VerseSearchController(bible: Bible(verseDataManager: VersesDataManager(persistentContainer: AppDelegate().persistentContainer)))
        controller.searchVerseDelegate = self
    }

    override func tearDown() {
        controller = nil
        testCase = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFilteredSearchString() {
        let firstSearch = "Matthew"
        controller.filterContentForSearchText(firstSearch)
        let secondSearch = "Matthew "
        controller.filterContentForSearchText(secondSearch)
        guard let book = controller.verseContainer.searchedBook else { return XCTFail()}
        let thirdSearch = "Matthew 5"
        controller.filterContentForSearchText(thirdSearch)
        let fourthSearch = "Matthew 5:"
        controller.filterContentForSearchText(fourthSearch)
        guard let chapter = controller.verseContainer.searchedChapter else { return XCTFail()}
        let fifthSearch = "Matthew 5:5"
        controller.filterContentForSearchText(fifthSearch)
        guard let verse = controller.verseContainer.searchedVerse else { return XCTFail()}
        XCTAssertEqual(fifthSearch, "\(book) \(chapter):\(verse)")
    }
    
    func testDidPressSearch() {
        let searchString = "Revelation 5:5"
        controller.filterContentForSearchText(searchString)
        controller.didPressSearch(for: searchString)
        guard let delegatedVerse = testCase else {return XCTFail()}
        XCTAssertEqual(searchString, delegatedVerse)
    }
    
    func testDidSelectItem() {
        let searchString = "Revelation "
        controller.filterContentForSearchText(searchString)
        controller.didSelectItem(at: 5)
        guard let chapter = controller.verseContainer.searchedChapter else {return XCTFail()}
        guard let book = controller.verseContainer.searchedBook else {return XCTFail()}
        XCTAssertEqual("Revelation 6", "\(book) \(chapter)")
    }
    
}

extension VerseSearchControllerTest: SearchVerseDelegate {
    
    func requestToOpenBibleVerse(book: String, chapter: Int, verse: Int) {
        testCase = "\(book) \(chapter):\(verse)"
    }
}
