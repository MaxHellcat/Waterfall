//
//  CollectionViewController.swift
//  Waterfall
//
//  Created by Max Reshetey on 22/12/2017.
//  Copyright © 2017 Max Reshetey. All rights reserved.
//

import UIKit

// Note, this app doesn't use newest prefetch techniques for collection view
class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, LayoutDelegate
{
	@IBOutlet var stepperView: UIStepper!
	@IBOutlet var paneView: PaneView!
	var refreshControl: UIRefreshControl!

	let networkManager = NetworkManager()

	var items = Array<Item>()

	var layout: CollectionViewLayout {
		return collectionView!.collectionViewLayout as! CollectionViewLayout
	}

	// MARK: - View lifecycle
	override func viewDidLoad()
	{
        super.viewDidLoad()

		layout.delegate = self

		configureStepperView()
		configureRefreshControl()

		fetchNextPage()
    }

    // MARK: - UICollectionViewDataSource related
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return items.count
	}

	// Note that in real projects we must be able to cancel request for cells that go away,
	// to avoid flickering and save traffic.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell

		let item = items[indexPath.item]

		cell.imageView.image = nil

		networkManager.fetchImage(url: item.imageUrl) { image in
			cell.imageView.image = image
		}

		// Of course some other loading decision can be used, using classic approach here
		if indexPath.item == self.items.count - networkManager.pageSize/2 {
			fetchNextPage()
		}

        return cell
    }

	// MARK: - LayoutDelegate related
	func heightForItem(at indexPath: IndexPath, itemWidth width: CGFloat) -> CGFloat
	{
		return width / CGFloat(items[indexPath.item].ratio)
	}

	func numberOfColumns() -> Int
	{
		return Int(stepperView.value)
	}

	// MARK: - Actions handlers
	@IBAction func stepperValueChanged(_ sender: UIStepper)
	{
		layout.invalidateLayout()
	}

	@objc
	func refreshTriggered(sender: UIRefreshControl)
	{
		networkManager.resetPageCounter()
		fetchNextPage()
	}

	// MARK: - Private methods
	fileprivate func fetchNextPage()
	{
		if networkManager.isInitialPage() {
			paneView.showIndicatorInSuperview(superview: self.view)
		}

		networkManager.fetchNextPage() { [weak self] items in

			guard let weakSelf = self else { return }

			// If we've pulled refresh, remove all data and cells first
			if weakSelf.refreshControl.isRefreshing
			{
				var indexPaths = Array<IndexPath>()

				for index in 0..<weakSelf.items.count
				{
					let indexPath = IndexPath(item: index, section: 0)
					indexPaths.append(indexPath)
				}

				weakSelf.items = []
				weakSelf.collectionView!.deleteItems(at: indexPaths)

				weakSelf.refreshControl.endRefreshing()
			}

			weakSelf.paneView.dismiss()

			guard let items = items else {
				weakSelf.paneView.showText(text: "Fetch failed.", superview: weakSelf.view)
				return
			}

			weakSelf.items += items

			var indexPaths = Array<IndexPath>()

			for index in 0..<items.count
			{
				let indexPath = IndexPath(item: weakSelf.items.count - items.count + index, section: 0)
				indexPaths.append(indexPath)
			}

			weakSelf.collectionView?.insertItems(at: indexPaths)
		}
	}

	fileprivate func configureStepperView()
	{
		self.view.addSubview(stepperView)

		stepperView.layer.cornerRadius = 4.0

		stepperView.translatesAutoresizingMaskIntoConstraints = false

		let centerX = NSLayoutConstraint(item: stepperView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)

		let centerY = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: stepperView, attribute: .bottom, multiplier: 1.0, constant: 20.0)

		self.view.addConstraints([centerX, centerY])
	}

	fileprivate func configureRefreshControl()
	{
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshTriggered(sender:)), for: .valueChanged)
		self.collectionView!.addSubview(refreshControl)

		self.refreshControl = refreshControl
	}

	// MARK: - Memory management
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
