//
//  PaneView.swift
//  Waterfall
//
//  Created by Max Reshetey on 22/12/2017.
//  Copyright © 2017 Max Reshetey. All rights reserved.
//

import UIKit

class PaneView: UIView
{
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	@IBOutlet weak var label: UILabel!

	func showText(text: String, superview view: UIView)
	{
		activityIndicator.stopAnimating()
		label.isHidden = false

		label.text = text

		showInSuperview(superview: view)
	}

	func showIndicatorInSuperview(superview: UIView)
	{
		label.isHidden = true

		activityIndicator.startAnimating()

		showInSuperview(superview: superview)
	}

	func dismiss()
	{
		removeFromSuperview()
	}

	fileprivate func showInSuperview(superview: UIView)
	{
		superview.addSubview(self)

		if translatesAutoresizingMaskIntoConstraints {
			translatesAutoresizingMaskIntoConstraints = false
		}

		let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 128.0)
		let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 128.0)

		let centerX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0)

		let centerY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0)

		superview.addConstraints([width, height, centerX, centerY])
	}
}
