//
//  PlacesMemStore.swift
//  Places
//
//  Created by Andressa Valengo on 04/02/25.
//

import Foundation

class PlacesMemStore: PlacesStoreProtocol, PlacesStoreUtilityProtocol {
  
  // MARK: - Data
    
  static var places = [
    Place(name: "Gula Gula", id: "123456"),
    Place(name: "American Breakfast", id: "234567")
  ]
  
  // MARK: - CRUD operations - Optional error
  
  func fetchPlaces(completionHandler: @escaping ([Place], PlacesStoreError?) -> Void) {
    completionHandler(type(of: self).places, nil)
  }
  
  func fetchPlace(id: String, completionHandler: @escaping (Place?, PlacesStoreError?) -> Void) {
    if let index = indexOfPlaceWithID(id: id) {
      let place = type(of: self).places[index]
      completionHandler(place, nil)
    } else {
      completionHandler(nil, PlacesStoreError.CannotFetch("Cannot fetch Place with id \(id)"))
    }
  }
  
  func createPlace(placeToCreate: Place, completionHandler: @escaping (Place?, PlacesStoreError?) -> Void) {
    var place = placeToCreate
    generatePlaceID(place: &place)
    type(of: self).places.append(place)
    completionHandler(place, nil)
  }
  
  
  func updatePlace(placeToUpdate: Place, completionHandler: @escaping (Place?, PlacesStoreError?) -> Void) {
    if let index = indexOfPlaceWithID(id: placeToUpdate.id) {
      type(of: self).places[index] = placeToUpdate
      let place = type(of: self).places[index]
      completionHandler(place, nil)
    } else {
      completionHandler(nil, PlacesStoreError.CannotUpdate("Cannot fetch Place with id \(String(describing: placeToUpdate.id)) to update"))
    }
  }
  
  func deletePlace(id: String, completionHandler: @escaping (Place?, PlacesStoreError?) -> Void) {
    if let index = indexOfPlaceWithID(id: id) {
      let place = type(of: self).places.remove(at: index)
      completionHandler(place, nil)
      return
    }
    completionHandler(nil, PlacesStoreError.CannotDelete("Cannot fetch Place with id \(id) to delete"))
  }
  
  // MARK: - CRUD operations - Generic enum result type
  
  func fetchPlaces(completionHandler: @escaping PlacesStoreFetchPlacesCompletionHandler) {
    completionHandler(PlacesStoreResult.Success(result: type(of: self).places))
  }
  
  func fetchPlace(id: String, completionHandler: @escaping PlacesStoreFetchPlaceCompletionHandler) {
    let place = type(of: self).places.filter { (place: Place) -> Bool in
      return place.id == id
      }.first
    if let place = place {
      completionHandler(PlacesStoreResult.Success(result: place))
    } else {
      completionHandler(PlacesStoreResult.Failure(error: PlacesStoreError.CannotFetch("Cannot fetch Place with id \(id)")))
    }
  }
  
  func createPlace(placeToCreate: Place, completionHandler: @escaping PlacesStoreCreatePlaceCompletionHandler) {
    var place = placeToCreate
    generatePlaceID(place: &place)
    type(of: self).places.append(place)
    completionHandler(PlacesStoreResult.Success(result: place))
  }
  
  func updatePlace(placeToUpdate: Place, completionHandler: @escaping PlacesStoreUpdatePlaceCompletionHandler) {
    if let index = indexOfPlaceWithID(id: placeToUpdate.id) {
      type(of: self).places[index] = placeToUpdate
      let place = type(of: self).places[index]
      completionHandler(PlacesStoreResult.Success(result: place))
    } else {
      completionHandler(PlacesStoreResult.Failure(error: PlacesStoreError.CannotUpdate("Cannot update Place with id \(String(describing: placeToUpdate.id)) to update")))
    }
  }
  
  func deletePlace(id: String, completionHandler: @escaping PlacesStoreDeletePlaceCompletionHandler) {
    if let index = indexOfPlaceWithID(id: id) {
      let place = type(of: self).places.remove(at: index)
      completionHandler(PlacesStoreResult.Success(result: place))
      return
    }
    completionHandler(PlacesStoreResult.Failure(error: PlacesStoreError.CannotDelete("Cannot delete Place with id \(id) to delete")))
  }
  
  // MARK: - CRUD operations - Inner closure
  
  func fetchPlaces(completionHandler: @escaping (() throws -> [Place]) -> Void) {
    completionHandler { return type(of: self).places }
  }
  
  func fetchPlace(id: String, completionHandler: @escaping (() throws -> Place?) -> Void) {
    if let index = indexOfPlaceWithID(id: id) {
      completionHandler { return type(of: self).places[index] }
    } else {
      completionHandler { throw PlacesStoreError.CannotFetch("Cannot fetch Place with id \(id)") }
    }
  }
  
  func createPlace(placeToCreate: Place, completionHandler: @escaping (() throws -> Place?) -> Void) {
    var place = placeToCreate
    generatePlaceID(place: &place)
    type(of: self).places.append(place)
    completionHandler { return place }
  }
  func updatePlace(placeToUpdate: Place, completionHandler: @escaping (() throws -> Place?) -> Void) {
    if let index = indexOfPlaceWithID(id: placeToUpdate.id) {
      type(of: self).places[index] = placeToUpdate
      let place = type(of: self).places[index]
      completionHandler { return place }
    } else {
      completionHandler { throw PlacesStoreError.CannotUpdate("Cannot fetch Place with id \(String(describing: placeToUpdate.id)) to update") }
    }
  }
  
  func deletePlace(id: String, completionHandler: @escaping (() throws -> Place?) -> Void) {
    if let index = indexOfPlaceWithID(id: id) {
      let place = type(of: self).places.remove(at: index)
      completionHandler { return place }
    } else {
      completionHandler { throw PlacesStoreError.CannotDelete("Cannot fetch Place with id \(id) to delete") }
    }
  }

  // MARK: - Convenience methods
  
  private func indexOfPlaceWithID(id: String?) -> Int? {
    return type(of: self).places.firstIndex { return $0.id == id }
  }
}
