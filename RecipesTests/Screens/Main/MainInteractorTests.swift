//
//  MainInteractorTests.swift
//  RecipesTests
//
//  Created by Damian Markowski on 25.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import XCTest
@testable import Recipes
@testable import RealmSwift

class MainInteractorTests: XCTestCase {
    
    var sut: MainInteractor!
    var presenter: MockMainPresenter!
    
    override func setUp() {
        super.setUp()
        sut = MainInteractor()
        presenter = MockMainPresenter()
        sut.presenter = presenter
    }
    
    func testFetchDataReturnsData(){
        let expectation = XCTestExpectation(description: "Fetch recipes")
        presenter.dataPassedToPresenter = {
            expectation.fulfill()
        }
        sut.fetchData()
        wait(for: [expectation], timeout: 3.0)
        XCTAssertTrue(presenter.recipes.count > 0)
    }
}

class MockMainPresenter: MainPresentationLogic{
    
    var recipes = [Recipe]()
    var dataPassedToPresenter: (()->())!
    
    func passRecipes(_ recipes: [Recipe]) {
        self.recipes = recipes
        dataPassedToPresenter()
    }
    
    func passError(_ error: String) {
        dataPassedToPresenter()
    }
}
