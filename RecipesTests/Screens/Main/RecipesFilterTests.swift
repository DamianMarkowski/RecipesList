//
//  RecipesFilterTests.swift
//  RecipesTests
//
//  Created by Damian Markowski on 25.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import XCTest
@testable import Recipes

class RecipesFilterTests: XCTestCase {
    
    var recipes = [Recipe]()
    
    override func setUp() {
        super.setUp()
        recipes = RecipesFactory.createRecipes()
    }
    
    func testSearchNameFilter(){
        let searchText = "Crock Pot"
        let filteredResult = createFilteredResult(searchText)
        XCTAssertEqual(filteredResult.count, 1)
    }
    
    func testSearchIngredientNameFilter(){
        let searchText = "brown gravy mix"
        let filteredResult = createFilteredResult(searchText)
        XCTAssertEqual(filteredResult.count, 1)
    }
    
    func testSearchInstructionFilter(){
        let searchText = "Pour"
        let filteredResult = createFilteredResult(searchText)
        XCTAssertEqual(filteredResult.count, 2)
    }
    
    func testFilterByComplexity(){
        let complexity = Complexity.Hard
        let filteredResult = RecipesFilter.filterByComplexity(complexity, recipes: recipes)
        XCTAssertEqual(filteredResult.count, 0)
    }
    
    func testFilterByPreparationTime(){
        let time = PreparationTime.Short
        let filteredResult = RecipesFilter.filterByPreparationTime(time, recipes: recipes)
        XCTAssertEqual(filteredResult.count, 1)
    }
    
    private func createFilteredResult(_ searchText: String) -> [Recipe] {
        return RecipesFilter.search(recipes, searchText: searchText)
    }
}
