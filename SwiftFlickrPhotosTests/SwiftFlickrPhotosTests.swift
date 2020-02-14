//
//  SwiftFlickrPhotosTests.swift
//  SwiftFlickrPhotosTests
//
//  Created by suraj poudel on 14/2/20.
//  Copyright © 2020 suraj poudel. All rights reserved.
//

import XCTest
@testable import SwiftFlickrPhotos

class SwiftFlickrPhotosTests: XCTestCase {

    var sut: URLSession!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = URLSession(configuration: .default)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testValidGetsHTTPStatusCode200(){
        // given
        let url = URL(string: FlickrConstants.searchURL)
           // 1
           let promise = expectation(description: "Status code: 200")
           
           // when
           let dataTask = sut.dataTask(with: url!) { data, response, error in
             // then
             if let error = error {
               XCTFail("Error: \(error.localizedDescription)")
               return
             } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
               if statusCode == 200 {
                 // 2
                 promise.fulfill()
               } else {
                 XCTFail("Status code: \(statusCode)")
               }
             }
           }
           dataTask.resume()
           // 3
           wait(for: [promise], timeout: 5)
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
