//
//  UIViewController.swift
//  Recipes
//
//  Created by Damian Markowski on 25.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureChildViewController(childController: UIViewController, onView: UIView) {
        addChildViewController(childController)
        onView.addSubview(childController.view)
        constrainViewEqual(holderView: onView, view: childController.view)
        childController.didMove(toParentViewController: self)
    }

    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: holderView, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: holderView, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: holderView, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: holderView, attribute: .bottom, multiplier: 1, constant: 0)
        holderView.addConstraints([leading, trailing, top, bottom])
    }
}
