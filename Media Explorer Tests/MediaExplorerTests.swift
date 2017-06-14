//
//  MediaExplorerTests.swift
//  MediaExplorerTests
//
//  Created by Alex Carrizo on 6/4/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Media_Explorer

class MediaExplorerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONConverter() {
        
        let testBundle = Bundle(for: type(of: self))
        guard let ressourceURL = testBundle.url(forResource: "FlickrGetSizes", withExtension: "json") else {
            // file does not exist
            return
        }
        do {
            let ressourceData = try Data(contentsOf: ressourceURL)
            let json = JSON(data: ressourceData)
            print(json)
            
        } catch let error {
            // some error occurred when reading the file
            print(error)
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
