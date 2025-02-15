//
//  CreatePlacePresenterTests.swift
//  Places
//
//  Created by Andressa Valengo on 15/02/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import Places
import XCTest

class CreatePlacePresenterTests: XCTestCase {
  // MARK: Subject under test
  
  var sut: CreatePlacePresenter!
  
  // MARK: Test lifecycle
  
  override func setUp() {
    super.setUp()
    setupCreatePlacePresenter()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupCreatePlacePresenter() {
    sut = CreatePlacePresenter()
  }
  
  // MARK: Test doubles
  
  class CreatePlaceDisplayLogicSpy: CreatePlaceDisplayLogic {
    var displaySomethingCalled = false
    
    func displaySomething(viewModel: CreatePlace.Something.ViewModel) {
      displaySomethingCalled = true
    }
  }
  
  // MARK: Tests
  
  func testPresentSomething() {
    // Given
    let spy = CreatePlaceDisplayLogicSpy()
    sut.viewController = spy
    let response = CreatePlace.Something.Response()
    
    // When
    sut.presentSomething(response: response)
    
    // Then
    XCTAssertTrue(spy.displaySomethingCalled, "presentSomething(response:) should ask the view controller to display the result")
  }
}
