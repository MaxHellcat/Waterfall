//
//  CollectionViewLayout.swift
//  Waterfall
//
//  Created by Max Reshetey on 22/12/2017.
//  Copyright © 2017 Max Reshetey. All rights reserved.
//

import UIKit

protocol LayoutDelegate: class
{
	func heightForItem(at indexPath: IndexPath, itemWidth width: CGFloat) -> CGFloat
	func numberOfColumns() -> Int
}

// Own implementation of a pinterest-like layout
class CollectionViewLayout: UICollectionViewLayout
{
	let itemSpacing: CGFloat = 8.0

	weak var delegate: LayoutDelegate!

	var attributesCache = [UICollectionViewLayoutAttributes]()

	var contentWidth: CGFloat {
		guard let collectionView = collectionView else { return 0.0 }
		return collectionView.bounds.width
	}
	var contentHeight: CGFloat = 0.0

	override var collectionViewContentSize: CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}

	// TODO: We don't need to recalculate cached values if we're here after new items' insertion, but
	// I conider this to be out of scope for this app
	override func prepare()
	{
		guard let collectionView = collectionView else { return }

		if !attributesCache.isEmpty {
			attributesCache.removeAll(keepingCapacity: true)
		}

		let numberOfColumns = delegate.numberOfColumns()

		var offsetY = Array<CGFloat>(repeating: 0.0, count: numberOfColumns)

		let itemWidth = collectionView.bounds.width / CGFloat(numberOfColumns) - CGFloat(numberOfColumns - 1)*(itemSpacing) / CGFloat(numberOfColumns)

		var column = 0
		for item in 0..<collectionView.numberOfItems(inSection: 0)
		{
			let itemX = CGFloat(column) * (itemWidth + itemSpacing)
			let itemY = offsetY[column]

			let indexPath = IndexPath(item: item, section: 0)
			let itemHeight = delegate.heightForItem(at: indexPath, itemWidth: itemWidth)

			let frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)

			let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
			attributes.frame = frame
			attributesCache.append(attributes)

			offsetY[column] += (itemHeight + itemSpacing)

			column = (column < numberOfColumns - 1) ? (column + 1) : 0
		}

		contentHeight = offsetY.max()! - itemSpacing
	}

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
	{
		var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

		for attributes in attributesCache
		{
			if attributes.frame.intersects(rect) {
				visibleLayoutAttributes.append(attributes)
			}
		}

		return visibleLayoutAttributes
	}

	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
	{
		return attributesCache[indexPath.item]
	}
}
