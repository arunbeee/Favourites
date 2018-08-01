//
//  SelectionDataLoaderTests.swift
//  FavouritesTests
//
//  Created by Arun Balakrishnan on 01/08/18.
//  Copyright © 2018 Arun Balakrishnan. All rights reserved.
//

import XCTest
@testable import Favourites


class SelectionDataLoaderTests: XCTestCase {
    
    let selectionDataLoader = SelectionDataLoader()
    
    func testDataLoading(){
        let theExpection = expectation(description: "Fetch data")
        
        self.selectionDataLoader.loadArticles { (articles) in
            XCTAssertNotNil(articles, "JSON format has changed")
            XCTAssertTrue(self.selectionDataLoader.articles.count > 0, "Did not receive any article")
            theExpection.fulfill()
        }
        
        wait(for: [theExpection], timeout: 10)
        
    }
    
    func testBadURLDataLoader(){
        let theExpection = expectation(description: "Fetch data")
        
        self.selectionDataLoader.loadArticles(endpoint:"") { (articles) in
            XCTAssertNil(articles, "Should not receive any JSON")
            XCTAssertTrue(self.selectionDataLoader.articles.count == 0, "Should not receive any article")
            theExpection.fulfill()
        }
        wait(for: [theExpection], timeout: 10)
    }
    
    func testSetArticlesLiked(){
        let theExpection = expectation(description: "Fetch data")
        
        self.selectionDataLoader.loadArticles { (articles) in
            self.selectionDataLoader.setArticleSelection(index: 0, isLiked: .liked)
            XCTAssertTrue(self.selectionDataLoader.articles.filter({$0.isLiked == .liked}).count == 1, "There article should have been selected")
            theExpection.fulfill()
        }
        wait(for: [theExpection], timeout: 10)
    }
    
    func testSetArticlesDisLiked(){
        let theExpection = expectation(description: "Fetch data")
        
        self.selectionDataLoader.loadArticles { (articles) in
            self.selectionDataLoader.setArticleSelection(index: 0, isLiked: .disLiked)
            XCTAssertTrue(self.selectionDataLoader.articles.filter({$0.isLiked == .disLiked}).count == 1, "There article should have been selected")
            theExpection.fulfill()
        }
        wait(for: [theExpection], timeout: 10)
    }
    
    func testLoadImageAtIndex(){
        let theExpection = expectation(description: "Fetch data")
        
        self.selectionDataLoader.loadArticles { (articles) in
            self.selectionDataLoader.loadImage(for: 0, completion: { (image) in
                XCTAssertNotNil(image, "Should have downloaded image")
                theExpection.fulfill()
            })
        }
        wait(for: [theExpection], timeout: 10)
    }
    
    
    func testLoadCachedImageAtIndex(){
        let theExpection = expectation(description: "Fetch data")
        
        self.selectionDataLoader.loadArticles { (articles) in
            self.selectionDataLoader.loadImage(for: 0, completion: { (image) in
                self.selectionDataLoader.loadImage(for: 0, completion: { (image) in
                    XCTAssertNotNil(image, "Should have downloaded image")
                    theExpection.fulfill()
                })
            })
        }
        wait(for: [theExpection], timeout: 10)
    }
    
    func testLoadDefaultImageAtIndex(){
        let theExpection = expectation(description: "Fetch data")
        self.selectionDataLoader.loadArticles { (articles) in
            self.selectionDataLoader.loadImage(for: 100000000, completion: { (image) in
                XCTAssertNotNil(image, "Should not have downloaded image")
                theExpection.fulfill()
            })
        }
        wait(for: [theExpection], timeout: 10)
    }
}
