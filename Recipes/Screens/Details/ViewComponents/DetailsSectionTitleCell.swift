//
//  DetailsSectionTitleCell.swift
//  Recipes
//
//  Created by Damian Markowski on 24.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import UIKit

class DetailsSectionTitleCell: UITableViewCell {

    // Views
    var titleLabel: UILabel!
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.lightGray
        addTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func addTitleLabel(){
        titleLabel = UILabel()
        self.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToTitleLabel()
    }
    
    private func addConstraintsToTitleLabel(){
        let leading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        self.contentView.addConstraints([leading, top, trailing, bottom])
    }
}
