//
//  RecipesFilter.swift
//  Recipes
//
//  Created by Damian Markowski on 25.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import Foundation

class RecipesFilter {
    
    class func search(_ recipes: [Recipe], searchText: String) -> [Recipe] {
        let result = recipes.filter { recipe -> Bool in
            return (recipe.name.contains(searchText) || recipe.ingredients.contains(where: { ingredient -> Bool in
                return ingredient.name.contains(searchText)
            }) || recipe.steps.contains(where: { instruction -> Bool in
                return instruction.contains(searchText)
            }))
        }
        return result
    }
    
    class func filterByComplexity(_ complexity: Complexity, recipes: [Recipe]) -> [Recipe] {
        var result = [Recipe]()
        switch complexity {
        case .Easy:
            result = recipes.filter { $0.steps.count < 5 }
        case .Medium:
            result = recipes.filter { $0.steps.count >= 5 && $0.steps.count < 10 }
        case .Hard:
            result = recipes.filter { $0.steps.count >= 10 }
        }
        return result
    }
    
    class func filterByPreparationTime(_ preparationTime: PreparationTime, recipes: [Recipe]) -> [Recipe] {
        var min = 0
        var max = 9
        switch preparationTime {
        case .Medium:
            min = 10
            max = 19
        case .Long:
            min = 20
        default:
            break
        }
        var result = [Recipe]()
        if min == 20 {
            result = recipes.filter { $0.timers.reduce(0, +) >= min }
        }else {
            result = recipes.filter { $0.timers.reduce(0, +) >= min && $0.timers.reduce(0, +) <= max }
        }
        return result
    }
}
