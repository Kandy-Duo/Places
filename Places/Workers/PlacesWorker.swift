//
//  PlacesWorker.swift
//  Places
//
//  Created by Andressa Valengo on 02/02/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

class PlacesWorker {
  var placesStore: PlacesStoreProtocol
    
    init(placesStore: PlacesStoreProtocol) {
      self.placesStore = placesStore
    }
    
    func fetchPlaces(completionHandler: @escaping ([Place]) -> Void) {
      placesStore.fetchPlaces { (places: () throws -> [Place]) -> Void in
        do {
          let places = try places()
          DispatchQueue.main.async {
            completionHandler(places)
          }
        } catch {
          DispatchQueue.main.async {
            completionHandler([])
          }
        }
      }
    }
    
    func createPlace(placeToCreate: Place, completionHandler: @escaping (Place?) -> Void) {
      placesStore.createPlace(placeToCreate: placeToCreate) { (place: () throws -> Place?) -> Void in
        do {
          let place = try place()
          DispatchQueue.main.async {
            completionHandler(place)
          }
        } catch {
          DispatchQueue.main.async {
            completionHandler(nil)
          }
        }
      }
    }
    
    func updatePlace(placeToUpdate: Place, completionHandler: @escaping (Place?) -> Void) {
      placesStore.updatePlace(placeToUpdate: placeToUpdate) { (place: () throws -> Place?) in
        do {
          let place = try place()
          DispatchQueue.main.async {
            completionHandler(place)
          }
        } catch {
          DispatchQueue.main.async {
            completionHandler(nil)
          }
        }
      }
    }
  }

  // MARK: - Places store API

  protocol PlacesStoreProtocol {
    // MARK: CRUD operations - Optional error
    
    func fetchPlaces(completionHandler: @escaping ([Place], PlacesStoreError?) -> Void)
    func fetchPlace(id: String, completionHandler: @escaping (Place?, PlacesStoreError?) -> Void)
    func createPlace(placeToCreate: Place, completionHandler: @escaping (Place?, PlacesStoreError?) -> Void)
    func updatePlace(placeToUpdate: Place, completionHandler: @escaping (Place?, PlacesStoreError?) -> Void)
    func deletePlace(id: String, completionHandler: @escaping (Place?, PlacesStoreError?) -> Void)
    
    // MARK: CRUD operations - Generic enum result type
    
    func fetchPlaces(completionHandler: @escaping PlacesStoreFetchPlacesCompletionHandler)
    func fetchPlace(id: String, completionHandler: @escaping PlacesStoreFetchPlaceCompletionHandler)
    func createPlace(placeToCreate: Place, completionHandler: @escaping PlacesStoreCreatePlaceCompletionHandler)
    func updatePlace(placeToUpdate: Place, completionHandler: @escaping PlacesStoreUpdatePlaceCompletionHandler)
    func deletePlace(id: String, completionHandler: @escaping PlacesStoreDeletePlaceCompletionHandler)
    
    // MARK: CRUD operations - Inner closure
    
    func fetchPlaces(completionHandler: @escaping (() throws -> [Place]) -> Void)
    func fetchPlace(id: String, completionHandler: @escaping (() throws -> Place?) -> Void)
    func createPlace(placeToCreate: Place, completionHandler: @escaping (() throws -> Place?) -> Void)
    func updatePlace(placeToUpdate: Place, completionHandler: @escaping (() throws -> Place?) -> Void)
    func deletePlace(id: String, completionHandler: @escaping (() throws -> Place?) -> Void)
  }

  protocol PlacesStoreUtilityProtocol {}

  extension PlacesStoreUtilityProtocol {
    func generatePlaceID(place: inout Place) {
      guard place.id == nil else { return }
      place.id = "\(arc4random())"
    }
  }

  // MARK: - Places store CRUD operation results

  typealias PlacesStoreFetchPlacesCompletionHandler = (PlacesStoreResult<[Place]>) -> Void
  typealias PlacesStoreFetchPlaceCompletionHandler = (PlacesStoreResult<Place>) -> Void
  typealias PlacesStoreCreatePlaceCompletionHandler = (PlacesStoreResult<Place>) -> Void
  typealias PlacesStoreUpdatePlaceCompletionHandler = (PlacesStoreResult<Place>) -> Void
  typealias PlacesStoreDeletePlaceCompletionHandler = (PlacesStoreResult<Place>) -> Void

  enum PlacesStoreResult<U> {
    case Success(result: U)
    case Failure(error: PlacesStoreError)
  }

  // MARK: - Places store CRUD operation errors

  enum PlacesStoreError: Equatable, Error {
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
  }

  func ==(lhs: PlacesStoreError, rhs: PlacesStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
    case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
    case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
    default: return false
    }
}
