//
//  RecipesFactory.swift
//  RecipesTests
//
//  Created by Damian Markowski on 25.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import Foundation
@testable import Recipes

class RecipesFactory {
    
    class func createRecipes() -> [Recipe]{
        return [createRecipe1(),createRecipe2()]
    }
    
    private class func createRecipe1() -> Recipe {
        let ingredient1 = Ingredient(quantity: "1", name: "beef roast", type: "Meat")
        let ingredient2 = Ingredient(quantity: "1 package", name: "brown gravy mix", type: "Baking")
        let ingredient3 = Ingredient(quantity: "1 package", name: "dried Italian salad dressing mix", type: "Condiments")
        let ingredients = [ingredient1, ingredient2, ingredient3]
        let recipe = Recipe(name: "Crock Pot Roast", ingredients: ingredients, steps: ["Place beef roast in crock pot.","Mix the dried mixes together in a bowl and sprinkle over the roast.","Pour the water around the roast."], timers: [1,2,5], imageURL: "http://img.sndimg.com/food/image/upload/w_266/v1/img/recipes/27/20/8/picVfzLZo.jpg", originalURL: "http://www.food.com/recipe/to-die-for-crock-pot-roast-27208")
        return recipe
    }
    
    private class func createRecipe2() -> Recipe {
        let ingredient1 = Ingredient(quantity: "1 lb", name: "asparagus", type: "Produce")
        let ingredient2 = Ingredient(quantity: "1 1/2 tbsp", name: "olive oil", type: "Condiments")
        let ingredient3 = Ingredient(quantity: "1/2 tsp", name: "kosher salt", type: "Baking")
        let ingredients = [ingredient1, ingredient2, ingredient3]
        let recipe = Recipe(name: "Roasted Asparagus", ingredients: ingredients, steps: ["Preheat oven to 425°F.","Cut off the woody bottom part of the asparagus spears and discard.","With a vegetable peeler, peel off the skin on the bottom 2-3 inches of the spears (this keeps the asparagus from being all.\",string.\", and if you eat asparagus you know what I mean by that).","Pour the water around the roast."], timers: [5,2,16,15], imageURL: "http://img.sndimg.com/food/image/upload/w_266/v1/img/recipes/50/84/7/picMcSyVd.jpg", originalURL: "http://www.food.com/recipe/roasted-asparagus-50847")
        return recipe
    }
}
