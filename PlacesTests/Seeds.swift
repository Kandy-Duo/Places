//
//  Seeds.swift
//  PlacesTests
//
//  Created by Andressa Valengo on 08/03/25.
//

@testable import Places
import XCTest

struct Seeds {
  struct Places {
    static let anyPlace = Place(name: "Any Place", id: "aaaaaaaa")
    static let anotherPlace = Place(name: "Another Place", id: "bbbbbbbb")
    static let newPlace = Place(name: "New Place", id: "cccccccc")
  }
}
