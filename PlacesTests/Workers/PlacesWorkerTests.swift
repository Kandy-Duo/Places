//
//  PlacesWorkerTests.swift
//  Places
//
//  Created by Andressa Valengo on 09/03/25.
//

@testable import Places
import XCTest

class PlacesWorkerTests: XCTestCase {
  
  // MARK: - Subject under test
    
    var sut: PlacesWorker!
    static var testPlaces: [Place]!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
      super.setUp()
      setupPlacesWorker()
    }
    
    override func tearDown() {
      super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupPlacesWorker() {
      sut = PlacesWorker(placesStore: PlacesMemStoreSpy())
      
      PlacesWorkerTests.testPlaces = [Seeds.Places.anyPlace, Seeds.Places.anotherPlace]
    }
    
    // MARK: - Test doubles
    
    class PlacesMemStoreSpy: PlacesMemStore {
      
      // MARK: Method call expectations
      
      var fetchPlacesCalled = false
      var createPlaceCalled = false
      var updatePlaceCalled = false
      
      // MARK: Spied methods
      
      override func fetchPlaces(completionHandler: @escaping (() throws -> [Place]) -> Void) {
        fetchPlacesCalled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
          completionHandler { () -> [Place] in
            return PlacesWorkerTests.testPlaces
          }
        }
      }
      
      override func createPlace(placeToCreate: Place, completionHandler: @escaping (() throws -> Place?) -> Void) {
        createPlaceCalled = true
        PlacesWorkerTests.testPlaces.append(placeToCreate)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
          completionHandler { () -> Place in
            return PlacesWorkerTests.testPlaces.last!
          }
        }
      }
      
      override func updatePlace(placeToUpdate: Place, completionHandler: @escaping (() throws -> Place?) -> Void) {
        updatePlaceCalled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
          completionHandler { () -> Place in
            return placeToUpdate
          }
        }
      }
    }
    
    // MARK: - Tests
    
    func testFetchPlacesShouldReturnListOfPlaces() {
      
      // Given
      let placesMemStoreSpy = sut.placesStore as! PlacesMemStoreSpy
      
      // When
      var fetchedPlaces = [Place]()
      let expect = expectation(description: "Wait for fetchPlaces() to return")
      sut.fetchPlaces { (Places) in
        fetchedPlaces = Places
        expect.fulfill()
      }
      waitForExpectations(timeout: 1.1)
      
      // Then
      XCTAssert(placesMemStoreSpy.fetchPlacesCalled, "Calling fetchPlaces() should ask the data store for a list of places")
      XCTAssertEqual(fetchedPlaces.count, PlacesWorkerTests.testPlaces.count, "fetchPlaces() should return a list of places")
      for Place in fetchedPlaces {
        XCTAssert(PlacesWorkerTests.testPlaces.contains(Place), "Fetched Places should match the Places in the data store")
      }
    }
    
    func testCreatePlaceshouldReturnTheCreatedPlace() {
      
      // Given
      let placesMemStoreSpy = sut.placesStore as! PlacesMemStoreSpy
      let placeToCreate = Seeds.Places.newPlace
      
      // When
      var createdPlace: Place?
      let expect = expectation(description: "Wait for createPlace() to return")
      sut.createPlace(placeToCreate: placeToCreate) { (Place) in
        createdPlace = Place
        expect.fulfill()
      }
      waitForExpectations(timeout: 1.1)
      
      // Then
      XCTAssert(placesMemStoreSpy.createPlaceCalled, "Calling createPlace() should ask the data store to create the new place")
      XCTAssertEqual(createdPlace, placeToCreate, "createPlace() should create the new place")
    }
    
    func testUpdatePlaceshouldReturnTheUpdatedPlace() {
      
      // Given
      let placesMemStoreSpy = sut.placesStore as! PlacesMemStoreSpy
      var placeToUpdate = PlacesWorkerTests.testPlaces.first!
      placeToUpdate.name = "Updated Name"
      
      // When
      var updatedPlace: Place?
      let expect = expectation(description: "Wait for updatePlace() to return")
      sut.updatePlace(placeToUpdate: placeToUpdate) { (place) in
        updatedPlace = place
        expect.fulfill()
      }
      waitForExpectations(timeout: 1.1)
      
      // Then
      XCTAssert(placesMemStoreSpy.updatePlaceCalled, "Calling updatePlace() should ask the data store to update the existing place")
      XCTAssertEqual(updatedPlace, placeToUpdate, "updatePlace() should update the existing place")
    }
}
