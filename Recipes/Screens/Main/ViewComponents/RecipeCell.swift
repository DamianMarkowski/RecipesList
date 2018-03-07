//
//  RecipeCell.swift
//  Recipes
//
//  Created by Damian Markowski on 23.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    
    // Views
    private var imageContainer: UIView!
    private var imageView: UIImageView!
    private var textsContainer: UIStackView!
    private var nameLabel: UILabel!
    private var ingredientsLabel: UILabel!
    private var preparationTimeLabel: UILabel!
    private var noImageLabel: UILabel!
    // Constants
    private let textsContainerSpacing: CGFloat = 7
    private let textFontSize: CGFloat = 10
    private let imageHeight: CGFloat = 60
    // Private properties
    private var recipe: Recipe!
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.lightGray
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    
    func configure(_ recipe: Recipe){
        self.recipe = recipe
        populateImage()
        populateLabels()
    }
    
    // MARK: Private methods
    
    private func addViews(){
        addImageContainer()
        addImageView()
        addNoImageLabel()
        addTextsContainer()
    }
    
    private func addImageContainer(){
        imageContainer = UIView()
        imageContainer.backgroundColor = UIColor.white
        self.contentView.addSubview(imageContainer)
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToImageContainer()
    }
    
    private func addConstraintsToImageContainer(){
        let leading = NSLayoutConstraint(item: imageContainer, attribute: .leading, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: imageContainer, attribute: .top, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: imageContainer, attribute: .trailing, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        self.contentView.addConstraints([leading, top, trailing])
    }
    
    private func addImageView(){
        imageView = UIImageView()
        configureImageView()
        imageContainer.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToImageView()
    }
    
    private func configureImageView(){
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.white
        imageView.clipsToBounds = true
    }
    
    private func addConstraintsToImageView(){
        let centerY = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: imageContainer, attribute: .centerY, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: imageContainer, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: imageContainer, attribute: .trailing, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageHeight)
        self.contentView.addConstraints([centerY, leading, trailing, height])
    }
    
    private func addNoImageLabel(){
        noImageLabel = UILabel()
        configureNoImageLabel()
        self.contentView.addSubview(noImageLabel)
        noImageLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToNoImageLabel()
    }
    
    private func configureNoImageLabel(){
        noImageLabel.isHidden = true
        noImageLabel.font = UIFont.systemFont(ofSize: 10)
        noImageLabel.textAlignment = .center
        noImageLabel.text = GlobalConstants.noImageLabelTitle
    }
    
    private func addConstraintsToNoImageLabel(){
        let centerX = NSLayoutConstraint(item: noImageLabel, attribute: .centerX, relatedBy: .equal, toItem: imageContainer, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: noImageLabel, attribute: .centerY, relatedBy: .equal, toItem: imageContainer, attribute: .centerY, multiplier: 1, constant: 0)
        self.contentView.addConstraints([centerX, centerY])
    }
    
    private func addTextsContainer(){
        textsContainer = UIStackView()
        configureTextsContainer()
        configureLabels()
        addLabelsToTextsContainer()
        self.contentView.addSubview(textsContainer)
        textsContainer.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToTextsContainer()
    }
    
    private func configureTextsContainer(){
        textsContainer.backgroundColor = UIColor.clear
        textsContainer.axis = .vertical
        textsContainer.distribution = .equalSpacing
        textsContainer.spacing = textsContainerSpacing
    }
    
    private func configureLabels(){
        configureNameLabel()
        configureIngredientsLabel()
        configurePreparationTimeLabel()
    }
    
    private func configureNameLabel(){
        nameLabel = UILabel()
        configureLabelCommon(nameLabel)
    }
    
    private func configureIngredientsLabel(){
        ingredientsLabel = UILabel()
        configureLabelCommon(ingredientsLabel)
    }
    
    private func configurePreparationTimeLabel(){
        preparationTimeLabel = UILabel()
        configureLabelCommon(preparationTimeLabel)
    }
    
    private func configureLabelCommon(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: textFontSize)
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
    }
    
    private func addLabelsToTextsContainer(){
        textsContainer.addArrangedSubview(nameLabel)
        textsContainer.addArrangedSubview(ingredientsLabel)
        textsContainer.addArrangedSubview(preparationTimeLabel)
    }
    
    private func addConstraintsToTextsContainer(){
        let leading = NSLayoutConstraint(item: textsContainer, attribute: .leading, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: textsContainer, attribute: .top, relatedBy: .equal, toItem: imageContainer, attribute: .bottom, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: textsContainer, attribute: .trailing, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: textsContainer, attribute: .bottom, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        self.contentView.addConstraints([leading, top, trailing, bottom])
    }
    
    private func populateImage(){
        imageView.loadImageUsingCache(withUrl: recipe.imageURL, completionHandler: {[weak self] success in
            self?.noImageLabel.isHidden = success
        })
    }
    
    private func populateLabels(){
        nameLabel.text = recipe.name
        ingredientsLabel.text = "\(recipe.ingredients.count) ingredients"
        preparationTimeLabel.text = "\(recipe.timers.reduce(0, +)) minutes"
    }
}
