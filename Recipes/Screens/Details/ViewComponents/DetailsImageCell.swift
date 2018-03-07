//
//  DetailsImageCell.swift
//  Recipes
//
//  Created by Damian Markowski on 24.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import UIKit

class DetailsImageCell: UITableViewCell {

    // Views
    var recipeImage: UIImageView!
    private var noImageLabel: UILabel!
    // Constants
    private let imageHeight: CGFloat = 200
    // Public properties
    var showNoImageLabel = false {
        didSet{
            self.noImageLabel.isHidden = !self.showNoImageLabel
        }
    }
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func addViews(){
        addRecipeImage()
        addNoImageLabel()
    }
    
    private func addRecipeImage(){
        recipeImage = UIImageView()
        recipeImage.contentMode = .scaleAspectFit
        self.contentView.addSubview(recipeImage)
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToImageView()
    }
    
    private func addConstraintsToImageView(){
        let leading = NSLayoutConstraint(item: recipeImage, attribute: .leading, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: recipeImage, attribute: .top, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: recipeImage, attribute: .trailing, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: recipeImage, attribute: .height, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .height, multiplier: 1, constant: 0)
        let containerHeight = NSLayoutConstraint(item: self.contentView.safeAreaLayoutGuide, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageHeight)
        self.contentView.addConstraints([leading, top, trailing, height, containerHeight])
    }
    
    private func addNoImageLabel(){
        noImageLabel = UILabel()
        noImageLabel.isHidden = true
        noImageLabel.text = GlobalConstants.noImageLabelTitle
        self.contentView.addSubview(noImageLabel)
        noImageLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToNoImageLabel()
    }
    
    private func addConstraintsToNoImageLabel(){
        let centerX = NSLayoutConstraint(item: noImageLabel, attribute: .centerX, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: noImageLabel, attribute: .centerY, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: 0)
        self.contentView.addConstraints([centerX, centerY])
    }
}
