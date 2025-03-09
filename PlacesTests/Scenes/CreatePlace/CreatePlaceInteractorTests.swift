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
    var presentCreatedPlaceCalled = false
    var presentPlaceToEditCalled = false
    var presentUpdatedPlaceCalled = false
    
    func presentCreatedPlace(response: CreatePlace.CreatePlace.Response) {
      presentCreatedPlaceCalled = true
    }
    
    func presentPlaceToEdit(response: CreatePlace.EditPlace.Response) {
      presentPlaceToEditCalled = true
    }
    
    func presentUpdatedPlace(response: CreatePlace.UpdatePlace.Response) {
      presentUpdatedPlaceCalled = true
    }
  }
  
  class PlacesWorkerSpy: PlacesWorker {
    
    // MARK: Method call expectations
    
    var createPlaceCalled = false
    var updatePlaceCalled = false
    
    // MARK: Spied methods
    
    override func createPlace(placeToCreate: Place, completionHandler: @escaping (Place?) -> Void) {
      createPlaceCalled = true
      completionHandler(Seeds.Places.anyPlace)
    }
    
    override func updatePlace(placeToUpdate: Place, completionHandler: @escaping (Place?) -> Void) {
      updatePlaceCalled = true
      completionHandler(Seeds.Places.anyPlace)
    }
  }
  
  // MARK: Test create a new place
  
  func testCreatePlaceShouldAskPlacesWorkerRoCreateTheNewPlaceAndPresenterToFormatIt() {
    // Given
    let createPlacePresentationLogicSpy = CreatePlacePresentationLogicSpy()
    sut.presenter = createPlacePresentationLogicSpy
    let placesWorkerSpy = PlacesWorkerSpy(placesStore: PlacesMemStore())
    sut.placesWorker = placesWorkerSpy
        
    // When
    let request = CreatePlace.CreatePlace.Request(placeInputFields: CreatePlace.PlaceInputFields(name: "Any Place"))
    sut.createPlace(request: request)
    
    // Then
    XCTAssertTrue(createPlacePresentationLogicSpy.presentCreatedPlaceCalled, "createPlace() should ask the presenter to format the newly created place")
    XCTAssertTrue(placesWorkerSpy.createPlaceCalled, "createPlace() should ask PlacesWorker to create the new place")
  }
  
  // MARK: Test edit a place
  
  func testShowPlaceToEditShouldAskPresenterToFormatTheExistingPlace() {
    // Given
    let createPlacePresentationLogicSpy = CreatePlacePresentationLogicSpy()
    sut.presenter = createPlacePresentationLogicSpy
    sut.placeToEdit = Seeds.Places.anyPlace
    
    // When
    let request = CreatePlace.EditPlace.Request()
    sut.showPlaceToEdit(request: request)
    
    // Then
    XCTAssertTrue(createPlacePresentationLogicSpy.presentPlaceToEditCalled, "showPlaceToEdit() should ask presenter to format the existing place")
  }
  
  func testShowPlaceToEditShouldNotAskPresentToFormatIfThereIsNotExistingPlace() {
    // Given
    let createPlacePresentationLogicSpy = CreatePlacePresentationLogicSpy()
    sut.presenter = createPlacePresentationLogicSpy
    sut.placeToEdit = nil
    
    // When
    let request = CreatePlace.EditPlace.Request()
    sut.showPlaceToEdit(request: request)
    
    // Then
    XCTAssertFalse(createPlacePresentationLogicSpy.presentPlaceToEditCalled, "showPlaceToEdit() should not ask present to format if there is no existing place")
  }
  
  // MARK: Test updating a place
  
  func testUpdatelaceShouldAskPlacesWorkerToUpdateTheExistingPlaceAndPresenterToFormatIt() {
    // Given
    let createPlacePresentationLogicSpy = CreatePlacePresentationLogicSpy()
    sut.presenter = createPlacePresentationLogicSpy
    let placesWorkerSpy = PlacesWorkerSpy(placesStore: PlacesMemStore())
    sut.placesWorker = placesWorkerSpy
    
    // When
    let request = CreatePlace.UpdatePlace.Request(placeInputFields: CreatePlace.PlaceInputFields(name: "any place", id: "any id"))
    sut.updatePlace(request: request)
    
    // Then
    XCTAssertTrue(createPlacePresentationLogicSpy.presentUpdatedPlaceCalled, "updatePlace() should ask presenter to format the updated place")
    XCTAssertTrue(placesWorkerSpy.updatePlaceCalled, "updatePlace() should ask PlacesWorker to update the existing place")
  }
}
