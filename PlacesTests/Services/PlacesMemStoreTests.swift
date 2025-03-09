//
//  PlacesMemStoreTests.swift
//  PlacesTests
//
//  Created by Andressa Valengo on 09/03/25.
//
@testable import Places
import XCTest

class PlacesMemStoreTests: XCTestCase {
  
  // MARK: - Subject under test
  
  var sut: PlacesMemStore!
  var testPlaces: [Place]!
  
  // MARK: - Test lifecycle
  
  override func setUp() {
    super.setUp()
    setupPlacesMemStore()
  }
  
  override func tearDown() {
    resetPlacesMemStore()
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupPlacesMemStore() {
    sut = PlacesMemStore()
    
    testPlaces = [Seeds.Places.anyPlace, Seeds.Places.anyPlace]
    
    PlacesMemStore.places = testPlaces
  }
  
  func resetPlacesMemStore() {
     PlacesMemStore.places = []
     sut = nil
   }
  
  // MARK: - Test CRUD operations - Optional error
    
    func testFetchPlacesShouldReturnListOfPlaces_OptionalError() {
      // Given
      
      // When
      var fetchedPlaces = [Place]()
      var fetchPlacesError: PlacesStoreError?
      let expect = expectation(description: "Wait for fetchPlaces() to return")
      sut.fetchPlaces { (places: [Place], error: PlacesStoreError?) -> Void in
        fetchedPlaces = places
        fetchPlacesError = error
        expect.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(fetchedPlaces.count, testPlaces.count, "fetchPlaces() should return a list of places")
      for place in fetchedPlaces {
        XCTAssert(testPlaces.contains(place), "Fetched places should match the places in the data store")
      }
      XCTAssertNil(fetchPlacesError, "fetchPlaces() should not return an error")
    }
    
    func testFetchPlacesShouldReturnPlace_OptionalError() {
      // Given
      let placeToFetch = testPlaces.first!
      
      // When
      var fetchedPlace: Place?
      var fetchPlaceError: PlacesStoreError?
      let expect = expectation(description: "Wait for fetchPlace() to return")
      sut.fetchPlace(id: placeToFetch.id!) { (place: Place?, error: PlacesStoreError?) -> Void in
        fetchedPlace = place
        fetchPlaceError = error
        expect.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(fetchedPlace, placeToFetch, "fetchPlace() should return a place")
      XCTAssertNil(fetchPlaceError, "fetchPlace() should not return an error")
    }
    
    func testCreatePlaceShouldCreateNewPlace_OptionalError() {
      // Given
      let placeToCreate = Seeds.Places.newPlace
      
      // When
      var createdPlace: Place?
      var creatPlaceError: PlacesStoreError?
      let createPlaceExpectation = expectation(description: "Wait for createPlace() to return")
      sut.createPlace(placeToCreate: placeToCreate) { (returnedPlace: Place?, error: PlacesStoreError?) -> Void in
        createdPlace = returnedPlace
        creatPlaceError = error
        createPlaceExpectation.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(createdPlace, placeToCreate, "createPlace() should create a new place")
      XCTAssertNil(creatPlaceError, "createPlace() should not return an error")
  }
    
    func testUpdatePlaceShouldUpdateExistingPlace_OptionalError() {
      // Given
      var placeToUpdate = testPlaces.first!
      placeToUpdate.name = "Updated Name"
      
      // When
      var updatedPlace: Place?
      var updatPlaceError: PlacesStoreError?
      let updatePlaceExpectation = expectation(description: "Wait for updatePlace() to return")
      sut.updatePlace(placeToUpdate: placeToUpdate) { (returnedPlace: Place?, error: PlacesStoreError?) -> Void in
        updatedPlace = returnedPlace
        updatPlaceError = error
        updatePlaceExpectation.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(updatedPlace, placeToUpdate, "updatePlace() should update an existing place")
      XCTAssertNil(updatPlaceError, "updatePlace() should not return an error")
    }
    
    func testDeletePlaceShouldDeleteExistingPlace_OptionalError() {
      // Given
      let placeToDelete = testPlaces.first!
      
      // When
      var deletedPlace: Place?
      var deletPlaceError: PlacesStoreError?
      let deletePlaceExpectation = expectation(description: "Wait for deletePlace() to return")
      sut.deletePlace(id: placeToDelete.id!) { (returnedPlace: Place?, error: PlacesStoreError?) -> Void in
        deletedPlace = returnedPlace
        deletPlaceError = error
        deletePlaceExpectation.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(deletedPlace, placeToDelete, "deletePlace() should delete an existing place")
      XCTAssertNil(deletPlaceError, "deletePlace() should not return an error")
    }
    
    // MARK: - Test CRUD operations - Generic enum result type
    
    func testFetchPlacesShouldReturnListOfPlaces_GenericEnumResultType() {
      // Given
      
      // When
      var fetchedPlaces = [Place]()
      var fetchPlacesError: PlacesStoreError?
      let expect = expectation(description: "Wait for fetchPlaces() to return")
      sut.fetchPlaces { (result: PlacesStoreResult<[Place]>) -> Void in
        switch (result) {
        case .Success(let places):
          fetchedPlaces = places
        case .Failure(let error):
          fetchPlacesError = error
          XCTFail("fetchPlaces() should not return an error: \(error)")
        }
        expect.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(fetchedPlaces.count, testPlaces.count, "fetchPlaces() should return a list of Places")
      for Place in fetchedPlaces {
        XCTAssert(testPlaces.contains(Place), "Fetched Places should match the Places in the data store")
      }
      XCTAssertNil(fetchPlacesError, "fetchPlaces() should not return an error")
    }
    
    func testFetchPlaceshouldReturnPlace_GenericEnumResultType() {
      // Given
      let placeToFetch = testPlaces.first!
      
      // When
      var fetchedPlace: Place?
      var fetchPlaceError: PlacesStoreError?
      let expect = expectation(description: "Wait for fetchPlace() to return")
      sut.fetchPlace(id: placeToFetch.id!) { (result: PlacesStoreResult<Place>) -> Void in
        switch (result) {
        case .Success(let Place):
          fetchedPlace = Place
        case .Failure(let error):
          fetchPlaceError = error
          XCTFail("fetchPlace() should not return an error: \(error)")
        }
        expect.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(fetchedPlace, placeToFetch, "fetchPlace() should return an Place")
      XCTAssertNil(fetchPlaceError, "fetchPlace() should not return an error")
    }
    
    func testCreatePlaceshouldCreateNewPlace_GenericEnumResultType() {
      // Given
      let placeToCreate = Seeds.Places.newPlace
      
      // When
      var createdPlace: Place?
      var creatPlaceError: PlacesStoreError?
      let createPlaceExpectation = expectation(description: "Wait for createPlace() to return")
      sut.createPlace(placeToCreate: placeToCreate) { (result: PlacesStoreResult<Place>) -> Void in
        switch (result) {
        case .Success(let returnedPlace):
          createdPlace = returnedPlace
        case .Failure(let error):
          creatPlaceError = error
          XCTFail("createPlace() should not return an error: \(error)")
        }
        createPlaceExpectation.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(createdPlace, placeToCreate, "createPlace() should create a new place")
      XCTAssertNil(creatPlaceError, "createPlace() should not return an error")
    }
    
    func testUpdatePlaceshouldUpdateExistingPlace_GenericEnumResultType() {
      // Given
      var placeToUpdate = testPlaces.first!
      placeToUpdate.name = "Updated Name"
      
      // When
      var updatedPlace: Place?
      var updatPlaceError: PlacesStoreError?
      let updatePlaceExpectation = expectation(description: "Wait for updatePlace() to return")
      sut.updatePlace(placeToUpdate: placeToUpdate) { (result: PlacesStoreResult<Place>) -> Void in
        switch (result) {
        case .Success(let returnedPlace):
          updatedPlace = returnedPlace
        case .Failure(let error):
          updatPlaceError = error
          XCTFail("updatePlace() should not return an error: \(error)")
        }
        updatePlaceExpectation.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(updatedPlace, placeToUpdate, "updatePlace() should update an existing place")
      XCTAssertNil(updatPlaceError, "updatePlace() should not return an error")
    }
    
    func testDeletePlaceshouldDeleteExistingPlace_GenericEnumResultType() {
      // Given
      let placeToDelete = testPlaces.first!
      
      // When
      var deletedPlace: Place?
      var deletePlaceError: PlacesStoreError?
      let deletePlaceExpectation = expectation(description: "Wait for deletePlace() to return")
      sut.deletePlace(id: placeToDelete.id!) { (result: PlacesStoreResult<Place>) -> Void in
        switch (result) {
        case .Success(let returnedPlace):
          deletedPlace = returnedPlace
          break
        case .Failure(let error):
          deletePlaceError = error
        }
        deletePlaceExpectation.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(deletedPlace, placeToDelete, "deletePlace() should delete an existing place")
      XCTAssertNil(deletePlaceError, "deletePlace() should not return an error")
    }
    
    // MARK: - Test CRUD operations - Inner closure
    
    func testFetchPlacesShouldReturnListOfPlaces_InnerClosure() {
      // Given
      
      // When
      var fetchedPlaces = [Place]()
      var fetchPlacesError: PlacesStoreError?
      let expect = expectation(description: "Wait for fetchPlaces() to return")
      sut.fetchPlaces { (Places: () throws -> [Place]) -> Void in
        do {
          fetchedPlaces = try Places()
        } catch let error as PlacesStoreError {
          fetchPlacesError = error
        } catch {}
        expect.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(fetchedPlaces.count, testPlaces.count, "fetchPlaces() should return a list of places")
      for Place in fetchedPlaces {
        XCTAssert(testPlaces.contains(Place), "Fetched Places should match the places in the data store")
      }
      XCTAssertNil(fetchPlacesError, "fetchPlaces() should not return an error")
    }
    
    func testFetchPlaceshouldReturnPlace_InnerClosure() {
      // Given
      let placeToFetch = testPlaces.first!
      
      // When
      var fetchedPlace: Place?
      var fetchPlaceError: PlacesStoreError?
      let expect = expectation(description: "Wait for fetchPlace() to return")
      sut.fetchPlace(id: placeToFetch.id!) { (Place: () throws -> Place?) -> Void in
        do {
          fetchedPlace = try Place()
        } catch let error as PlacesStoreError {
          fetchPlaceError = error
        } catch {}
        expect.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(fetchedPlace, placeToFetch, "fetchPlace() should return an place")
      XCTAssertNil(fetchPlaceError, "fetchPlace() should not return an error")
    }
    
    func testCreatePlaceshouldCreateNewPlace_InnerClosure() {
      // Given
      let placeToCreate = Seeds.Places.newPlace
      
      // When
      var createdPlace: Place?
      var creatPlaceError: PlacesStoreError?
      let createPlaceExpectation = expectation(description: "Wait for createPlace() to return")
      sut.createPlace(placeToCreate: placeToCreate) { (Place: () throws -> Place?) -> Void in
        _ = try! Place()
        do {
          createdPlace = try Place()
        } catch let error as PlacesStoreError {
          creatPlaceError = error
        } catch {}
        createPlaceExpectation.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(createdPlace, placeToCreate, "createPlace() should create a new place")
      XCTAssertNil(creatPlaceError, "createPlace() should not return an error")
    }
    
    func testUpdatePlaceshouldUpdateExistingPlace_InnerClosure() {
      // Given
      var placeToUpdate = testPlaces.first!
      placeToUpdate.name = "Updated Name"
      
      // When
      var updatedPlace: Place?
      var updatPlaceError: PlacesStoreError?
      let updatePlaceExpectation = expectation(description: "Wait for updatePlace() to return")
      sut.updatePlace(placeToUpdate: placeToUpdate) { (Place: () throws -> Place?) -> Void in
        do {
          updatedPlace = try Place()
        } catch let error as PlacesStoreError {
          updatPlaceError = error
        } catch {}
        updatePlaceExpectation.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(updatedPlace, placeToUpdate, "updatePlace() should update an existing place")
      XCTAssertNil(updatPlaceError, "updatePlace() should not return an error")
    }
    
    func testDeletePlaceshouldDeleteExistingPlace_InnerClosure() {
      // Given
      let placeToDelete = testPlaces.first!
      
      // When
      var deletedPlace: Place?
      var deletePlaceError: PlacesStoreError?
      let deletePlaceExpectation = expectation(description: "Wait for deletePlace() to return")
      sut.deletePlace(id: placeToDelete.id!) { (Place: () throws -> Place?) -> Void in
        do {
          deletedPlace = try Place()
        } catch let error as PlacesStoreError {
          deletePlaceError = error
        } catch {}
        deletePlaceExpectation.fulfill()
      }
      waitForExpectations(timeout: 1.0)
      
      // Then
      XCTAssertEqual(deletedPlace, placeToDelete, "deletePlace() should delete an existing place")
      XCTAssertNil(deletePlaceError, "deletePlace() should not return an error")
    }
}
