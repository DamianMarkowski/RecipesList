//
//  MainRouter.swift
//  Recipes
//
//  Created by Damian Markowski on 21.02.2018.
//  Copyright (c) 2018 Damian Markowski. All rights reserved.

import UIKit

protocol MainRoutingLogic {
    func navigateToDetailsScreen(_ selectedRecipe: Recipe)
}

class MainRouter: NSObject, MainRoutingLogic {
  
    // Clean Swift Architecture layers
    weak var viewController: MainViewController?
 
    func navigateToDetailsScreen(_ selectedRecipe: Recipe){
        let targetScreen = DetailsViewController()
        targetScreen.recipe = selectedRecipe
        viewController?.show(targetScreen, sender: nil)
    }
}
