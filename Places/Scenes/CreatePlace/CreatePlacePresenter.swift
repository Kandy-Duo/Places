//
//  CreatePlacePresenter.swift
//  Places
//
//  Created by Andressa Valengo on 24/01/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CreatePlacePresentationLogic {
  func presentCreatedPlace(response: CreatePlace.CreatePlace.Response)
  func presentPlaceToEdit(response: CreatePlace.EditPlace.Response)
  func presentUpdatedPlace(response: CreatePlace.UpdatePlace.Response)
}

class CreatePlacePresenter: CreatePlacePresentationLogic {

  weak var viewController: CreatePlaceDisplayLogic?
  
  // MARK: - Create place
  
  func presentCreatedPlace(response: CreatePlace.CreatePlace.Response) {
    let viewModel = CreatePlace.CreatePlace.ViewModel()
    viewController?.displayCreatedPlace(viewModel: viewModel)
  }
  
  // MARK: - Edit place
  
  func presentPlaceToEdit(response: CreatePlace.EditPlace.Response) {
    let placeToEdit = response.place
    let viewModel = CreatePlace.EditPlace.ViewModel(
      placeInputFields: CreatePlace.PlaceInputFields(
        name: placeToEdit.name,
        id: placeToEdit.id)
    )
    viewController?.displayPlaceToEdit(viewModel: viewModel)
  }
  
  // MARK: - Update place
  
  func presentUpdatedPlace(response: CreatePlace.UpdatePlace.Response) {
    let viewModel = CreatePlace.UpdatePlace.ViewModel(place: response.place)
    viewController?.displayUpdatedPlace(viewModel: viewModel)
  }
}
