//
//  DetailsIngredientCell.swift
//  Recipes
//
//  Created by Damian Markowski on 24.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import UIKit

class DetailsIngredientCell: UITableViewCell {

    // Views
    private var labelsContainer: UIStackView!
    var nameLabel: UILabel!
    var quantityLabel: UILabel!
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addLabelsContainer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func addLabelsContainer(){
        labelsContainer = UIStackView()
        labelsContainer.axis = .horizontal
        labelsContainer.distribution = .fillEqually
        addNameLabel()
        addQuantityLabel()
        self.contentView.addSubview(labelsContainer)
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToLabelsContainer()
    }
    
    private func addNameLabel(){
        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        labelsContainer.addArrangedSubview(nameLabel)
    }
    
    private func addQuantityLabel(){
        quantityLabel = UILabel()
        quantityLabel.textAlignment = .right
        labelsContainer.addArrangedSubview(quantityLabel)
    }
    
    private func addConstraintsToLabelsContainer(){
        let leading = NSLayoutConstraint(item: labelsContainer, attribute: .leading, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: labelsContainer, attribute: .top, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: labelsContainer, attribute: .trailing, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: labelsContainer, attribute: .bottom, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        self.contentView.addConstraints([leading, top, trailing, bottom])
    }
}
