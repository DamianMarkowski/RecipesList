//
//  MainModels.swift
//  Recipes
//
//  Created by Damian Markowski on 21.02.2018.
//  Copyright (c) 2018 Damian Markowski. All rights reserved.

import UIKit
import RealmSwift

struct Recipe: Codable {
    var name: String
    var ingredients: [Ingredient]
    var steps: [String]
    var timers: [Int]
    var imageURL: String
    var originalURL: String?
}

struct Ingredient: Codable {
    var quantity: String
    var name: String
    var type: String
}

enum Complexity: String {
    case Easy
    case Medium
    case Hard
}

enum PreparationTime: String {
    case Short = "0-10 min"
    case Medium = "10-20 min"
    case Long = "20+ min"
}

class RecipeCacheModel: Object {
    @objc dynamic var name = ""
    var ingredients = List<IngredientCacheModel>()
    var steps = List<String>()
    var timers = List<Int>()
    @objc dynamic var imageURL = ""
    @objc dynamic var originalURL: String? = nil
}

class IngredientCacheModel: Object {
    @objc dynamic var quantity = ""
    @objc dynamic var name = ""
    @objc dynamic var type = ""
}
