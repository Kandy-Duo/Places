//
//  CreatePlaceViewControllerTests.swift
//  Places
//
//  Created by Andressa Valengo on 15/02/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import Places
import XCTest

class CreatePlaceViewControllerTests: XCTestCase {
  // MARK: Subject under test
  
  var sut: CreatePlaceViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp() {
    super.setUp()
    window = UIWindow()
    setupCreatePlaceViewController()
  }
  
  override func tearDown() {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupCreatePlaceViewController() {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "CreatePlaceViewController") as! CreatePlaceViewController
  }
  
  func loadView() {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  // MARK: Tests
}
