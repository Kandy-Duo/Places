//
//  CreatePlaceWorkerTests.swift
//  Places
//
//  Created by Andressa Valengo on 15/02/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import Places
import XCTest

class CreatePlaceWorkerTests: XCTestCase {
  // MARK: Subject under test
  
  var sut: CreatePlaceWorker!
  
  // MARK: Test lifecycle
  
  override func setUp() {
    super.setUp()
    setupCreatePlaceWorker()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupCreatePlaceWorker() {
    sut = CreatePlaceWorker()
  }
  
  // MARK: Test doubles
  
  // MARK: Tests
  
  func testSomething() {
    // Given
    
    // When
    
    // Then
  }
}
