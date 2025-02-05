//
//  CreatePlaceInteractor.swift
//  Places
//
//  Created by Andressa Valengo on 24/01/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CreatePlaceBusinessLogic {
  var placeToEdit: Place? { get }
  func isPlaceNameValid(name: String) -> Bool
  func createPlace(request: CreatePlace.CreatePlace.Request)
  func showPlaceToEdit(request: CreatePlace.EditPlace.Request)
  func updatePlace(request: CreatePlace.UpdatePlace.Request)
}

protocol CreatePlaceDataStore {
  var placeToEdit: Place? { get set }
}

class CreatePlaceInteractor: CreatePlaceBusinessLogic, CreatePlaceDataStore {
  
  var presenter: CreatePlacePresentationLogic?
  
  var placesWorker = PlacesWorker(placesStore: PlacesMemStore())
  var placeToEdit: Place?
  
  // MARK: - Create place
  
  func createPlace(request: CreatePlace.CreatePlace.Request) {
    let placeToCreate = buildPlaceFromPlaceInputFields(request.placeInputFields)
    
    placesWorker.createPlace(placeToCreate: placeToCreate) { (place: Place?) in
      self.placeToEdit = place
      let response = CreatePlace.CreatePlace.Response(place: place)
      self.presenter?.presentCreatedPlace(response: response)
    }
  }
  
  // MARK: - Edit place
  
  func showPlaceToEdit(request: CreatePlace.EditPlace.Request) {
    if let placeToEdit = placeToEdit {
      let response = CreatePlace.EditPlace.Response(place: placeToEdit)
      presenter?.presentPlaceToEdit(response: response)
    }
  }
  
  // MARK: - Update order
  
  func updatePlace(request: CreatePlace.UpdatePlace.Request) {
    let placeToUpdate = buildPlaceFromPlaceInputFields(request.placeInputFields)
    
    placesWorker.updatePlace(placeToUpdate: placeToUpdate) { (place) in
      self.placeToEdit = place
      let response = CreatePlace.UpdatePlace.Response(place: place)
      self.presenter?.presentUpdatedPlace(response: response)
    }
  }
  
  func isPlaceNameValid(name: String) -> Bool {
    if (name.isEmpty) {
      return false
    }
    return true
  }
    
  // MARK: - Helper function
    
  private func buildPlaceFromPlaceInputFields(_ placeInputFields: CreatePlace.PlaceInputFields) -> Place {
    return Place(name: placeInputFields.name, id: placeInputFields.id)
  }
}
