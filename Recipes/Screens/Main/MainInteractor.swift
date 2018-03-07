//
//  MainInteractor.swift
//  Recipes
//
//  Created by Damian Markowski on 21.02.2018.
//  Copyright (c) 2018 Damian Markowski. All rights reserved.

import UIKit
import RealmSwift

protocol MainBusinessLogic {
    func fetchData()
    func searchForRecipes(_ searchText: String)
    func filterRecipesByComplexity(_ complexity: Complexity)
    func filterRecipesByPreparationTime(_ preparationTime: PreparationTime)
}

class MainInteractor: MainBusinessLogic {
    
    // Clean Swift Architecture layers
    var presenter: MainPresentationLogic?
    // Constants
    private let apiUrl = "http://damianmarkowski.pl/apis/recipes.json"
    private let noDataErrorMessage = "No data was fetched."
    private let recipesCacheDateKey = "recipesCacheDateKey"
    // Public properties
    var httpClient: HTTPClient = HTTPClient()
    // Private properties
    private var recipes: [Recipe] = []
    private let userDefaults = UserDefaults()
    
    // MARK: Public methods
    
    func fetchData(){
        if let data = try? Realm().objects(RecipeCacheModel.self) {
            if data.count > 0 {
                if checkIfShouldInvalidateCache() {
                    fetchDataFromServer()
                }else{
                    mapDataFromCache(Array(data))
                }
            }else{
                fetchDataFromServer()
            }
        }else{
            fetchDataFromServer()
        }
    }
    
    func searchForRecipes(_ searchText: String){
        let recipes = RecipesFilter.search(self.recipes, searchText: searchText)
        self.presenter?.passRecipes(recipes)
    }
    
    func filterRecipesByComplexity(_ complexity: Complexity){
        let recipes = RecipesFilter.filterByComplexity(complexity, recipes: self.recipes)
        self.presenter?.passRecipes(recipes)
    }
    
    func filterRecipesByPreparationTime(_ preparationTime: PreparationTime){
        let recipes = RecipesFilter.filterByPreparationTime(preparationTime, recipes: self.recipes)
        self.presenter?.passRecipes(recipes)
    }
    
    // MARK: Private methods
    
    private func fetchDataFromServer(){
        guard let url = createUrl() else { return }
        httpClient.get(url) {[weak self] (data, error) in
            guard error == nil else {
                self?.presenter?.passError(error!.localizedDescription)
                return
            }
            guard let result = data else {
                if let message = self?.noDataErrorMessage {
                    self?.presenter?.passError(message)
                }
                return
            }
            self?.parseData(result)
        }
    }
    
    private func mapDataFromCache(_ data: [RecipeCacheModel]){
        var recipes = [Recipe]()
        for recipeCacheModel in data {
            var ingredients = [Ingredient]()
            for ingredientCacheModel in recipeCacheModel.ingredients {
                let ingredient = Ingredient(quantity: ingredientCacheModel.quantity, name: ingredientCacheModel.name, type: ingredientCacheModel.type)
                ingredients.append(ingredient)
            }
            let recipe = Recipe(name: recipeCacheModel.name, ingredients: ingredients, steps: Array(recipeCacheModel.steps), timers: Array(recipeCacheModel.timers), imageURL: recipeCacheModel.imageURL, originalURL: recipeCacheModel.originalURL)
            recipes.append(recipe)
        }
        self.recipes = recipes
        self.presenter?.passRecipes(recipes)
    }
    
    private func createUrl() -> URL? {
        return URL(string: apiUrl)
    }
    
    private func parseData(_ data: Data){
        let decoder = JSONDecoder()
        do {
            let recipes = try decoder.decode([Recipe].self, from: data)
            self.recipes = recipes
            cacheData()
        } catch {
            self.presenter?.passError(error.localizedDescription)
        }
    }
    
    private func cacheData(){
        for recipe in self.recipes {
            try? Realm().write {
                try? Realm().add(createCacheModel(recipe))
            }
        }
        userDefaults.set(NSDate(), forKey: recipesCacheDateKey)
        self.presenter?.passRecipes(recipes)
    }
    
    private func createCacheModel(_ recipe: Recipe) -> RecipeCacheModel {
        let recipeCacheModel = RecipeCacheModel()
        recipeCacheModel.name = recipe.name
        recipeCacheModel.steps.append(objectsIn: recipe.steps)
        recipeCacheModel.timers.append(objectsIn: recipe.timers)
        recipeCacheModel.imageURL = recipe.imageURL
        recipeCacheModel.originalURL = recipe.originalURL
        let ingredients = List<IngredientCacheModel>()
        for ingredient in recipe.ingredients {
            let ingredientCacheModel = IngredientCacheModel()
            ingredientCacheModel.quantity = ingredient.quantity
            ingredientCacheModel.name = ingredient.name
            ingredientCacheModel.type = ingredient.type
            ingredients.append(ingredientCacheModel)
        }
        recipeCacheModel.ingredients = ingredients
        return recipeCacheModel
    }
    
    private func checkIfShouldInvalidateCache() -> Bool {
        let secondsInOneHour = 3600
        if let date = userDefaults.object(forKey: recipesCacheDateKey) as? Date {
            let components: Set<Calendar.Component> = [.second]
            let difference = NSCalendar.current.dateComponents(components, from: date, to: Date())
            if let seconds = difference.second {
                return seconds >= secondsInOneHour
            }
        }
        return true
    }
}
