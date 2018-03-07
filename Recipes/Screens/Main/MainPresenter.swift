//
//  MainPresenter.swift
//  Recipes
//
//  Created by Damian Markowski on 21.02.2018.
//  Copyright (c) 2018 Damian Markowski. All rights reserved.

import UIKit

protocol MainPresentationLogic {
    func passRecipes(_ recipes: [Recipe])
    func passError(_ error: String)
}

class MainPresenter: MainPresentationLogic {
  
    // Clean Swift Architecture layers
    weak var viewController: MainDisplayLogic?
    
    // MARK: Public methods
    
    func passRecipes(_ recipes: [Recipe]){
        viewController?.displayRecipes(recipes)
    }
    
    func passError(_ error: String){
        viewController?.displayError(error)
    }
}
