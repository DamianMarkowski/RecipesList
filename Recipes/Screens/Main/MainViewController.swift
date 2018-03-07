//
//  MainViewController.swift
//  Recipes
//
//  Created by Damian Markowski on 21.02.2018.
//  Copyright (c) 2018 Damian Markowski. All rights reserved.

import UIKit

protocol MainDisplayLogic: class {
    func displayRecipes(_ recipes: [Recipe])
    func displayError(_ error: String)
}

class MainViewController: UIViewController, MainDisplayLogic {
  
    // Clean Swift Architecture layers
    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol & MainRoutingLogic)?
    // Views
    private var searchTextContainer: UIView!
    private var searchText: UITextField!
    private var filterButtonsContainer: UIStackView!
    private var list: UICollectionView!
    private var activityIndicator: UIActivityIndicatorView!
    private var complexityFilterContainer: UIView!
    private var preparationTimeFilterContainer: UIView!
    private var complexityButton: UIButton!
    private var preparationTimeButton: UIButton!
    private var clearFiltersButton: UIButton!
    // Constants
    private let searchTextVerticalMargin: CGFloat = 20
    private let searchTextHorizontalMargin: CGFloat = 15
    private let searchTextHeight: CGFloat = 40
    private let filterContainerHeight: CGFloat = 100
    private let filterButtonContainerHorizontalMargin: CGFloat = 10
    private let recipeCellIdentifier = "RecipeCell"
    private let errorAlertOkButtonTitle = "Ok"
    private let complexityButtonTitle = "Complexity"
    private let preparationTimeButtonTitle = "Time"
    private let clearFilterButtonTitle = "x"
    // Private properties
    private var recipes: [Recipe] = []
  
    // MARK: Setup
  
    private func setup() {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
  
    // MARK: View lifecycle
  
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        searchText.text = nil
        interactor?.fetchData()
    }
    
    // MARK: Public methods
    
    func displayRecipes(_ recipes: [Recipe]){
        self.recipes = recipes
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.list.reloadData()
        }
    }
    
    func displayError(_ error: String){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.present(self.createAlert(error), animated: true, completion: nil)
        }
    }
    
    // MARK: Private methods
    
    private func addViews(){
        addSearchTextContainer()
        addSearchText()
        addFilterButtonsContainer()
        addList()
        addFilterContainers()
        addActivityIndicatorView()
    }
    
    private func addSearchTextContainer(){
        searchTextContainer = UIView()
        view.addSubview(searchTextContainer)
        searchTextContainer.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToSearchTextContainer()
    }
    
    private func addConstraintsToSearchTextContainer(){
        let leading = NSLayoutConstraint(item: searchTextContainer, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: searchTextContainer, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: searchTextContainer, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        view.addConstraints([leading, top, right])
    }
    
    private func addSearchText(){
        searchText = UITextField()
        configureSearchText()
        searchTextContainer.addSubview(searchText)
        searchText.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToSearchText()
    }
    
    private func configureSearchText(){
        searchText.layer.borderWidth = 1
        searchText.layer.cornerRadius = 10
        searchText.autocapitalizationType = .none
        searchText.autocorrectionType = .no
        searchText.addTarget(self, action: #selector(MainViewController.searchTextDidEndEditing), for: .editingChanged)
    }
    
    @objc private func searchTextDidEndEditing(){
        if let text = searchText.text, text.count > 0 {
            self.interactor?.searchForRecipes(text)
        }else{
            self.interactor?.fetchData()
        }
    }
    
    private func addConstraintsToSearchText(){
        let leading = NSLayoutConstraint(item: searchText, attribute: .leading, relatedBy: .equal, toItem: searchTextContainer, attribute: .leading, multiplier: 1, constant: searchTextHorizontalMargin)
        let trailing = NSLayoutConstraint(item: searchTextContainer, attribute: .trailing, relatedBy: .equal, toItem: searchText, attribute: .trailing, multiplier: 1, constant: searchTextHorizontalMargin)
        let height = NSLayoutConstraint(item: searchText, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: searchTextHeight)
        let top = NSLayoutConstraint(item: searchText, attribute: .top, relatedBy: .equal, toItem: searchTextContainer, attribute: .top, multiplier: 1, constant: searchTextVerticalMargin)
        let bottom = NSLayoutConstraint(item: searchTextContainer, attribute: .bottom, relatedBy: .equal, toItem: searchText, attribute: .bottom, multiplier: 1, constant: searchTextVerticalMargin)
        searchTextContainer.addConstraints([leading, trailing, height, top, bottom])
    }
    
    private func addFilterButtonsContainer(){
        filterButtonsContainer = UIStackView()
        configureFilterButtonsContainer()
        addFilterButtons()
        view.addSubview(filterButtonsContainer)
        addClearFiltersButton()
        filterButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToFiltersContainer()
    }
    
    private func configureFilterButtonsContainer(){
        filterButtonsContainer.axis = .horizontal
        filterButtonsContainer.distribution = .equalSpacing
    }
    
    private func addFilterButtons(){
        addComplexityFilterButton()
        addPreparationTimeFilterButton()
    }
    
    private func addComplexityFilterButton(){
        complexityButton = UIButton()
        complexityButton.setTitle(complexityButtonTitle, for: .normal)
        complexityButton.titleLabel?.textAlignment = .center
        complexityButton.setTitleColor(UIColor.black, for: .normal)
        complexityButton.addTarget(self, action: #selector(MainViewController.updateComplexityFilterVisibility), for: .touchUpInside)
        filterButtonsContainer.addArrangedSubview(complexityButton)
    }
    
    @objc private func updateComplexityFilterVisibility(){
        complexityFilterContainer.isHidden = !complexityFilterContainer.isHidden
    }
    
    private func addPreparationTimeFilterButton(){
        preparationTimeButton = UIButton()
        preparationTimeButton.setTitle(preparationTimeButtonTitle, for: .normal)
        preparationTimeButton.titleLabel?.textAlignment = .center
        preparationTimeButton.setTitleColor(UIColor.black, for: .normal)
        preparationTimeButton.addTarget(self, action: #selector(MainViewController.updatePreparationTimeFilterVisibility), for: .touchUpInside)
        filterButtonsContainer.addArrangedSubview(preparationTimeButton)
    }
    
    @objc private func updatePreparationTimeFilterVisibility(){
        preparationTimeFilterContainer.isHidden = !preparationTimeFilterContainer.isHidden
    }
    
    private func addClearFiltersButton(){
        clearFiltersButton = UIButton()
        clearFiltersButton.setTitle(clearFilterButtonTitle, for: .normal)
        clearFiltersButton.setTitleColor(UIColor.black, for: .normal)
        clearFiltersButton.addTarget(self, action: #selector(MainViewController.clearFilters), for: .touchUpInside)
        view.addSubview(clearFiltersButton)
        view.bringSubview(toFront: clearFiltersButton)
        clearFiltersButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToClearFiltersButton()
    }
    
    @objc private func clearFilters(){
        complexityButton.setTitle(complexityButtonTitle, for: .normal)
        preparationTimeButton.setTitle(preparationTimeButtonTitle, for: .normal)
        interactor?.fetchData()
    }
    
    private func addConstraintsToClearFiltersButton(){
        let centerX = NSLayoutConstraint(item: clearFiltersButton, attribute: .centerX, relatedBy: .equal, toItem: filterButtonsContainer, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: clearFiltersButton, attribute: .centerY, relatedBy: .equal, toItem: filterButtonsContainer, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraints([centerX, centerY])
    }
    
    private func addConstraintsToFiltersContainer(){
        let leading = NSLayoutConstraint(item: filterButtonsContainer, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: filterButtonContainerHorizontalMargin)
        let trailing = NSLayoutConstraint(item: filterButtonsContainer, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -filterButtonContainerHorizontalMargin)
        let top = NSLayoutConstraint(item: filterButtonsContainer, attribute: .top, relatedBy: .equal, toItem: searchTextContainer, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([leading, trailing, top])
    }
    
    private func addList(){
        list = UICollectionView(frame: view.frame, collectionViewLayout: createCollectionViewLayout())
        configureList()
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToList()
    }
    
    private func createCollectionViewLayout() -> ColumnsFlowLayout {
        let columnsLayout = ColumnsFlowLayout(
            cellsPerRow: 2,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets.zero
        )
        return columnsLayout
    }
    
    private func configureList(){
        list.contentInsetAdjustmentBehavior = .always
        list.backgroundColor = UIColor.clear
        list.dataSource = self
        list.delegate = self
        list.register(RecipeCell.self, forCellWithReuseIdentifier: recipeCellIdentifier)
    }
    
    private func addConstraintsToList(){
        let leading = NSLayoutConstraint(item: list, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: list, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: list, attribute: .top, relatedBy: .equal, toItem: filterButtonsContainer, attribute: .bottom, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: list, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([leading, trailing, top, bottom])
    }
    
    private func addFilterContainers(){
        addComplexityFilterContainer()
        addPreparationTimeFilterContainer()
    }
    
    private func addComplexityFilterContainer(){
        complexityFilterContainer = UIView()
        complexityFilterContainer.isHidden = true
        view.addSubview(complexityFilterContainer)
        complexityFilterContainer.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToComplexityFilterContainer()
        configureChildViewController(childController: createComplexityDropDownMenu(), onView: complexityFilterContainer)
    }
    
    private func createComplexityDropDownMenu() -> UIViewController {
        let complexityDropDownMenu = DropDownMenuController()
        complexityDropDownMenu.view.frame = complexityFilterContainer.frame
        complexityDropDownMenu.data = [Complexity.Easy.rawValue,Complexity.Medium.rawValue,Complexity.Hard.rawValue]
        complexityDropDownMenu.cellTapped = {[unowned self] row in
            var complexity = Complexity.Easy
            switch row {
            case 1:
                complexity = Complexity.Medium
            case 2:
                complexity = Complexity.Hard
            default:
                break
            }
            self.updateComplexityFilterVisibility()
            self.preparationTimeFilterContainer.isHidden = true
            self.complexityButton.setTitle(complexity.rawValue, for: .normal)
            self.interactor?.filterRecipesByComplexity(complexity)
        }
        return complexityDropDownMenu
    }
    
    private func addConstraintsToComplexityFilterContainer(){
        let leading = NSLayoutConstraint(item: complexityFilterContainer, attribute: .leading, relatedBy: .equal, toItem: filterButtonsContainer, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: complexityFilterContainer, attribute: .top, relatedBy: .equal, toItem: filterButtonsContainer, attribute: .bottom, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: complexityFilterContainer, attribute: .width, relatedBy: .equal, toItem: filterButtonsContainer, attribute: .width, multiplier: 0.5, constant: 0)
        let height = NSLayoutConstraint(item: complexityFilterContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: filterContainerHeight)
        view.addConstraints([leading, top, width, height])
    }
    
    private func addPreparationTimeFilterContainer(){
        preparationTimeFilterContainer = UIView()
        preparationTimeFilterContainer.isHidden = true
        view.addSubview(preparationTimeFilterContainer)
        preparationTimeFilterContainer.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToPreparationTimeFilterContainer()
        configureChildViewController(childController: createPreparationTimeDropDownMenu(), onView: preparationTimeFilterContainer)
    }
    
    private func createPreparationTimeDropDownMenu() -> UIViewController {
        let preparationTimeDropDownMenu = DropDownMenuController()
        preparationTimeDropDownMenu.view.frame = preparationTimeFilterContainer.frame
        preparationTimeDropDownMenu.data = [PreparationTime.Short.rawValue,PreparationTime.Medium.rawValue,PreparationTime.Long.rawValue]
        preparationTimeDropDownMenu.cellTapped = {[unowned self] row in
            var preparationTime = PreparationTime.Short
            switch row {
            case 1:
                preparationTime = PreparationTime.Medium
            case 2:
                preparationTime = PreparationTime.Long
            default:
                break
            }
            self.updatePreparationTimeFilterVisibility()
            self.complexityFilterContainer.isHidden = true
            self.preparationTimeButton.setTitle(preparationTime.rawValue, for: .normal)
            self.interactor?.filterRecipesByPreparationTime(preparationTime)
        }
        return preparationTimeDropDownMenu
    }
    
    private func addConstraintsToPreparationTimeFilterContainer(){
        let trailing = NSLayoutConstraint(item: preparationTimeFilterContainer, attribute: .trailing, relatedBy: .equal, toItem: filterButtonsContainer, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: preparationTimeFilterContainer, attribute: .top, relatedBy: .equal, toItem: filterButtonsContainer, attribute: .bottom, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: preparationTimeFilterContainer, attribute: .width, relatedBy: .equal, toItem: filterButtonsContainer, attribute: .width, multiplier: 0.5, constant: 0)
        let height = NSLayoutConstraint(item: preparationTimeFilterContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: filterContainerHeight)
        view.addConstraints([trailing, top, width, height])
    }
    
    private func addActivityIndicatorView(){
        activityIndicator = UIActivityIndicatorView()
        configureActivityIndicatorView()
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToActivityIndicatorView()
    }
    
    private func configureActivityIndicatorView(){
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.gray
    }
    
    private func addConstraintsToActivityIndicatorView(){
        let centerX = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraints([centerX, centerY])
    }
    
    private func createAlert(_ title: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: errorAlertOkButtonTitle, style: .default, handler: nil))
        return alert
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCellIdentifier, for: indexPath) as! RecipeCell
        cell.configure(recipes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRecipe = recipes[indexPath.row]
        router?.navigateToDetailsScreen(selectedRecipe)
    }
}
