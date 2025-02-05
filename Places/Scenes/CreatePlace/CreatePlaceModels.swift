//
//  CreatePlaceModels.swift
//  Places
//
//  Created by Andressa Valengo on 24/01/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum CreatePlace {
  
  struct PlaceInputFields {
    
    // MARK: Place info
    var name: String
    
    var id: String?
  }
  
  // MARK: Use cases
  
  enum CreatePlace {
    struct Request {
      var placeInputFields: PlaceInputFields
    }
    struct Response {
      var place: Place?
    }
    struct ViewModel {
      var place: Place?
    }
  }
  
  enum EditPlace {
    struct Request {
    }
    struct Response {
      var place: Place
    }
    struct ViewModel {
      var placeInputFields: PlaceInputFields
    }
  }
  
  enum UpdatePlace {
    struct Request {
      var placeInputFields: PlaceInputFields
    }
    struct Response {
      var place: Place?
    }
    struct ViewModel {
      var place: Place?
    }
  }
}
