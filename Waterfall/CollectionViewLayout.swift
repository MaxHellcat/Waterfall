//
//  CollectionViewLayout.swift
//  Waterfall
//
//  Created by Max Reshetey on 20/12/2017.
//  Copyright © 2017 Max Reshetey. All rights reserved.
//

import UIKit

protocol CollectionViewLayout

class CollectionViewLayout: UICollectionViewLayout
{
	func prepare()
	{
		
		
	}
	
	
//	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
//	{
//		let attributes = super.layoutAttributesForElements(in: rect)!
//
//		guard attributes.count > 0 else { return attributes }
//
//		let attributesCopy = attributes.map { $0.copy() } as! [UICollectionViewLayoutAttributes]
//
//		// First row to top
//		let item = attributesCopy[1]
//		item.frame.origin.y = 0
//		let prevItem = attributesCopy[0]
//		prevItem.frame.origin.y = 0
//
//		guard attributes.count > 1 else { return attributes }
//
//		for i in 2..<attributesCopy.count
//		{
//			let item = attributesCopy[i]
//			let prevPrevItem = attributesCopy[i-2]
//
//			print("Item \(i) center \(item.center)")
//			print("Item \(i-2) center \(prevPrevItem.center)")
//			print()
//
//			item.frame.origin.y = prevPrevItem.frame.maxY + 8.0
//		}
//
//		let lastItem = attributesCopy[attributesCopy.count-1]
//
////		contentSize = CGSize(width: 0, height: 0)
////
////		contentSize!.height = lastItem.frame.maxY + 8.0
////		contentSize!.width = collectionView!.bounds.width
//
//		print("See attr count: \(attributesCopy.count)")
//
//		return attributesCopy
//	}

//	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
//	{
//		let attributes = super.layoutAttributesForItem(at: indexPath)!
//
//		let attributesCopy = attributes.copy() as! UICollectionViewLayoutAttributes
//
//		print("See attr")
//
//		attributesCopy.center.x += 2
//
//		return attributesCopy
//	}
}
