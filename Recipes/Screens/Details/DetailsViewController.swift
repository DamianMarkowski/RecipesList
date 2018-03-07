//
//  DetailsViewController.swift
//  Recipes
//
//  Created by Damian Markowski on 21.02.2018.
//  Copyright (c) 2018 Damian Markowski. All rights reserved.

import UIKit

class DetailsViewController: UIViewController {
  
    // Public properties
    var recipe: Recipe!
    // Views
    private var list: UITableView!
    // Private properties
    private var imageUrl: String!
    // Constants
    private let listHorizontalMargin: CGFloat = 10
    
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        populateImageUrl()
        addList()
    }
    
    // MARK: Private methods
    
    private func populateImageUrl(){
        imageUrl = recipe.originalURL != nil ? recipe.originalURL : recipe.imageURL
    }
    
    private func addList(){
        list = UITableView()
        configureList()
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToList()
    }
    
    private func configureList(){
        list.dataSource = self
        list.delegate = self
        list.estimatedRowHeight = 70
        list.rowHeight = UITableViewAutomaticDimension
        list.tableFooterView = UIView()
        registerCells()
    }
    
    private func registerCells(){
        list.register(DetailsImageCell.classForCoder(), forCellReuseIdentifier: DetailsCellIdentifier.Image.rawValue)
        list.register(DetailsTitleCell.classForCoder(), forCellReuseIdentifier: DetailsCellIdentifier.Title.rawValue)
        list.register(DetailsSectionTitleCell.classForCoder(), forCellReuseIdentifier: DetailsCellIdentifier.SectionTitle.rawValue)
        list.register(DetailsIngredientCell.classForCoder(), forCellReuseIdentifier: DetailsCellIdentifier.Ingredient.rawValue)
        list.register(DetailsInstructionCell.classForCoder(), forCellReuseIdentifier: DetailsCellIdentifier.Instruction.rawValue)
    }
    
    private func addConstraintsToList(){
        let leading = NSLayoutConstraint(item: list, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: listHorizontalMargin)
        let top = NSLayoutConstraint(item: list, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: list, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -listHorizontalMargin)
        let bottom = NSLayoutConstraint(item: list, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([leading, top, trailing, bottom])
    }
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculateSumNumberOfRows()
    }
    
    private func calculateSumNumberOfRows() -> Int {
        var sum = 2
        if checkIfIngredientsNotEmpty() {
            sum += (recipe.ingredients.count + 1)
        }
        if checkIfStepsNotEmpty() {
            sum += (recipe.steps.count + 1)
        }
        return sum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if checkIfIngredientsNotEmpty() && checkIfStepsNotEmpty() {
            return createCellWhenAllElementsPresent(tableView, indexPath: indexPath)
        }else if checkIfIngredientsNotEmpty() {
            return createCellWhenIngredientsPresent(tableView, indexPath:indexPath)
        }else if checkIfStepsNotEmpty() {
            return createCellWhenStepsPresent(tableView, indexPath:indexPath)
        }else{
            return createCellWhenOnlyBasicDataPresent(tableView, indexPath: indexPath)
        }
    }
    
    private func checkIfIngredientsNotEmpty() -> Bool {
        return recipe.ingredients.count > 0
    }
    
    private func checkIfStepsNotEmpty() -> Bool {
        return recipe.steps.count > 0
    }
    
    private func createCellWhenAllElementsPresent(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Image.rawValue, for: indexPath) as! DetailsImageCell
                cell.recipeImage.loadImageUsingCache(withUrl: imageUrl, completionHandler: {success in
                    cell.showNoImageLabel = !success
                    cell.layoutIfNeeded()
                })
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Title.rawValue, for: indexPath) as! DetailsTitleCell
                cell.titleLabel.text = recipe.name
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.SectionTitle.rawValue, for: indexPath) as! DetailsSectionTitleCell
                cell.titleLabel.text = "Ingredients \(recipe.ingredients.count)"
                return cell
            case 3...recipe.ingredients.count+2:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Ingredient.rawValue, for: indexPath) as! DetailsIngredientCell
                let ingredient = recipe.ingredients[indexPath.row-3]
                cell.nameLabel.text = "\(ingredient.name)"
                cell.quantityLabel.text = "\(ingredient.quantity)"
                return cell
            case recipe.ingredients.count+4...(calculateSumNumberOfRows()-1):
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Instruction.rawValue, for: indexPath) as! DetailsInstructionCell
                cell.titleLabel.text = "\(recipe.steps[indexPath.row-(recipe.ingredients.count+4)])"
                return cell
            case recipe.ingredients.count+3:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.SectionTitle.rawValue, for: indexPath) as! DetailsSectionTitleCell
                cell.titleLabel.text = "Instructions"
                return cell
            default:
                break
        }
        return UITableViewCell()
    }
    
    private func createCellWhenIngredientsPresent(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Image.rawValue, for: indexPath) as! DetailsImageCell
            cell.recipeImage.loadImageUsingCache(withUrl: imageUrl, completionHandler: {success in
                cell.showNoImageLabel = !success
                cell.layoutIfNeeded()
            })
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Title.rawValue, for: indexPath) as! DetailsTitleCell
            cell.titleLabel.text = recipe.name
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.SectionTitle.rawValue, for: indexPath) as! DetailsSectionTitleCell
            cell.titleLabel.text = "Ingredients \(recipe.ingredients.count)"
            return cell
        case 3...recipe.ingredients.count+2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Ingredient.rawValue, for: indexPath) as! DetailsIngredientCell
            let ingredient = recipe.ingredients[indexPath.row-3]
            cell.nameLabel.text = "\(ingredient.name)"
            cell.quantityLabel.text = "\(ingredient.quantity)"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private func createCellWhenStepsPresent(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Image.rawValue, for: indexPath) as! DetailsImageCell
            cell.recipeImage.loadImageUsingCache(withUrl: imageUrl, completionHandler: {success in
                cell.showNoImageLabel = !success
                cell.layoutIfNeeded()
            })
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Title.rawValue, for: indexPath) as! DetailsTitleCell
            cell.titleLabel.text = recipe.name
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.SectionTitle.rawValue, for: indexPath) as! DetailsSectionTitleCell
            cell.titleLabel.text = "Instructions"
            return cell
        case 3...recipe.steps.count+2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Instruction.rawValue, for: indexPath) as! DetailsInstructionCell
            cell.titleLabel.text = "\(recipe.steps[indexPath.row-3])"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private func createCellWhenOnlyBasicDataPresent(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Image.rawValue, for: indexPath) as! DetailsImageCell
            cell.recipeImage.loadImageUsingCache(withUrl: imageUrl, completionHandler: {success in
                cell.showNoImageLabel = !success
                cell.layoutIfNeeded()
            })
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier.Title.rawValue, for: indexPath) as! DetailsTitleCell
            cell.titleLabel.text = recipe.name
            return cell
        default:
            return UITableViewCell()
        }
    }
}
