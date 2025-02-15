//
//  CreatePlaceInteractorTests.swift
//  Places
//
//  Created by Andressa Valengo on 15/02/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import Places
import XCTest

class CreatePlaceInteractorTests: XCTestCase {
  // MARK: Subject under test
  
  var sut: CreatePlaceInteractor!
  
  // MARK: Test lifecycle
  
  override func setUp() {
    super.setUp()
    setupCreatePlaceInteractor()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupCreatePlaceInteractor() {
    sut = CreatePlaceInteractor()
  }
  
  // MARK: Test doubles
  
  class CreatePlacePresentationLogicSpy: CreatePlacePresentationLogic {
    var presentSomethingCalled = false
    
    func presentSomething(response: CreatePlace.Something.Response) {
      presentSomethingCalled = true
    }
  }
  
  // MARK: Tests
  
  func testDoSomething() {
    // Given
    let spy = CreatePlacePresentationLogicSpy()
    sut.presenter = spy
    let request = CreatePlace.Something.Request()
    
    // When
    sut.doSomething(request: request)
    
    // Then
    XCTAssertTrue(spy.presentSomethingCalled, "doSomething(request:) should ask the presenter to format the result")
  }
}
