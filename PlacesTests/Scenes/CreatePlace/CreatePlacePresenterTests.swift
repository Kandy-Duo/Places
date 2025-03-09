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
    
    // MARK: Method call expectations
    
    var displayCreatedPlaceCalled = false
    var displayPlaceToEditCalled = false
    var displayUpdatedPlaceCalled = false
    
    // MARK: Argument expectations
    
    var createPlaceViewModel: CreatePlace.CreatePlace.ViewModel!
    var editPlaceViewModel: CreatePlace.EditPlace.ViewModel!
    var updatePlaceViewModel: CreatePlace.UpdatePlace.ViewModel!
    
    // MARK: Spied methods
    
    func displayCreatedPlace(viewModel: CreatePlace.CreatePlace.ViewModel) {
      displayCreatedPlaceCalled = true
      self.createPlaceViewModel = viewModel
    }
    
    func displayPlaceToEdit(viewModel: CreatePlace.EditPlace.ViewModel) {
      displayPlaceToEditCalled = true
      self.editPlaceViewModel = viewModel
    }
    
    func displayUpdatedPlace(viewModel: CreatePlace.UpdatePlace.ViewModel) {
      displayUpdatedPlaceCalled = true
      self.updatePlaceViewModel = viewModel
    }
  }
  
  class CreatePlaceDisplayLogicMock: CreatePlaceDisplayLogic {
    
    // MARK: Method call expectations
    
    var displayCreatedPlaceCalled = false
    var displayPlaceToEditCalled = false
    var displayUpdatedPlaceCalled = false
    
    // MARK: Argument expectations
    
    var createPlaceViewModel: CreatePlace.CreatePlace.ViewModel!
    var editPlaceViewModel: CreatePlace.EditPlace.ViewModel!
    var updatePlaceViewModel: CreatePlace.UpdatePlace.ViewModel!
    
    // MARK: Spied methods
    
    func displayCreatedPlace(viewModel: CreatePlace.CreatePlace.ViewModel) {
      displayCreatedPlaceCalled = true
      createPlaceViewModel = viewModel
    }
    
    func displayPlaceToEdit(viewModel: CreatePlace.EditPlace.ViewModel) {
      displayPlaceToEditCalled = true
      editPlaceViewModel = viewModel
    }
    
    func displayUpdatedPlace(viewModel: CreatePlace.UpdatePlace.ViewModel) {
      displayUpdatedPlaceCalled = true
      updatePlaceViewModel = viewModel
    }
    
    // MARK: Verifications
    
    func verifyEditPlaceViewModelPlaceInputFields(place: Place) -> Bool {
      return editPlaceViewModel.placeInputFields.name == place.name &&
      editPlaceViewModel.placeInputFields.id == place.id
    }
  }
  
  // MARK: Test created place
  
  func testPresentCreatedPlaceShouldAskViewControllerToDisplayTheNewlyCreatedPlace() {
    
    // Given
    let createPlaceDisplayLogicSpy = CreatePlaceDisplayLogicSpy()
    sut.viewController = createPlaceDisplayLogicSpy
    
    // When
    let place = Seeds.Places.anyPlace
    let response = CreatePlace.CreatePlace.Response(place: place)
    sut.presentCreatedPlace(response: response)
    
    // Then
    XCTAssertTrue(createPlaceDisplayLogicSpy.displayCreatedPlaceCalled, "presentCreatedPlace(response:) should ask the view controller to display the newly created place")
    XCTAssertNotNil(createPlaceDisplayLogicSpy.createPlaceViewModel.place, "presenting the newly created place should succeed")
  }
  
  // MARK: Test editing place
  func testPresentPlaceToEditShouldFormatTheExistingPlaceForDisplayUsingSpy() {
    
    // Given
    let createPlaceDisplayLogicSpy = CreatePlaceDisplayLogicSpy()
    sut.viewController = createPlaceDisplayLogicSpy
    
    // When
    let place = Seeds.Places.anyPlace
    let response = CreatePlace.EditPlace.Response(place: place)
    sut.presentPlaceToEdit(response: response)
    
    // Then
    XCTAssertTrue(createPlaceDisplayLogicSpy.displayPlaceToEditCalled, "presentPlaceToEdit(response:) should ask the view contrller to display the place to edit")
    XCTAssertEqual(createPlaceDisplayLogicSpy.editPlaceViewModel.placeInputFields.name, place.name, "resentPlaceToEdit(response:) should format the existing place")
    XCTAssertEqual(createPlaceDisplayLogicSpy.editPlaceViewModel.placeInputFields.id, place.id, "resentPlaceToEdit(response:) should format the existing place")
  }
  
  func testPresentPlaceToEditShouldFormatTheExistngPlaceForDisplayUsingMock() {
    
    // Given
    let createPlaceDisplayLoginMock = CreatePlaceDisplayLogicMock()
    sut.viewController = createPlaceDisplayLoginMock
    
    // When
    let place = Seeds.Places.anyPlace
    let response = CreatePlace.EditPlace.Response(place: place)
    sut.presentPlaceToEdit(response: response)
    
    // Then
    XCTAssertTrue(createPlaceDisplayLoginMock.displayPlaceToEditCalled, "presentPlaceToEdit(response:) should ask the view contrller to display the place to edit")
    XCTAssertTrue(createPlaceDisplayLoginMock.verifyEditPlaceViewModelPlaceInputFields(place: place), "resentPlaceToEdit(response:) should format the existing place")
  }
  
  // MARK: Test updating a place
  
  func testPresentupdatedPlaceShouldAskViewControllerToDisplayTheUpdatedPlace() {
    
    // Given
    let createPlaceDisplayLogicSpy = CreatePlaceDisplayLogicSpy()
    sut.viewController = createPlaceDisplayLogicSpy
    
    // When
    let place = Seeds.Places.anyPlace
    let response = CreatePlace.UpdatePlace.Response(place: place)
    sut.presentUpdatedPlace(response: response)
    
    // Then
    XCTAssertTrue(createPlaceDisplayLogicSpy.displayUpdatedPlaceCalled, "presentUpdatedPlace(response:) should ask the view controler to display the edited place")
    XCTAssertNotNil(createPlaceDisplayLogicSpy.updatePlaceViewModel.place, "presenting the edited place should succeed")
  }
}
