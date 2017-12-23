//
//  NetworkManager.swift
//  Waterfall
//
//  Created by Max Reshetey on 22/12/2017.
//  Copyright © 2017 Max Reshetey. All rights reserved.
//

import UIKit

// NOTE, using own simple manager here to demonstrate skills only.
// In real project we could and should use full-fledged network frameworks
// like AFNetworking, Alamofire, etc.

// ALSO NOTE, no any caching mechanism is implemented here for downloaded data.
// Caching is provided by full-fledged network frameworks.

// AGAIN NOTE, due to simplicity, no cancelling is possible for the requests, as a result
// fast scrolling in collections can and will flicker.
// Cancelling is provided by full-fledged network frameworks.

// Simple network manager that fetches metadata and images asyncronously
class NetworkManager
{
	private let kBaseUrl = "http://coub.com/api/v2"
	let pageSize = 25

	var currentPage = 1

	func fetchNextPage(completion: @escaping (Array<Item>?) -> Void)
	{
		fetchPage(page: currentPage, completion: completion)

		currentPage += 1
	}

	func resetPageCounter()
	{
		currentPage = 1
	}

	func isInitialPage() -> Bool
	{
		return currentPage == 1
	}
	
	// MARK: - Private methods
	fileprivate func fetchPage(page: Int, completion: @escaping (Array<Item>?) -> Void)
	{
		let url = URL(string: kBaseUrl + "/" + "timeline/explore/rising?page=\(page)&per_page=\(pageSize)")!

		print("Network: Fetching page \(page)")

		DispatchQueue.global(qos: .background).async {

			let data = try? Data(contentsOf: url)

			DispatchQueue.main.async {

				// NOTE, in real projects we should use some high-level parsing framework, like SwiftyJSON, JSONKit, etc.
				guard let data = data,
					let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
					completion(nil)
					return
				}

				guard let json = jsonObject as? Dictionary<String, AnyObject> else {
					completion(nil)
					return
				}

				var items = Array<Item>()

				for itemJson in json["coubs"] as! [Dictionary<String, AnyObject>]
				{
					let imagePath = itemJson["picture"] as! String
					let imageUrl = URL(string: imagePath)!
					
					print("\(items.count): \(itemJson["title"]!)")

					let dimensions = itemJson["dimensions"] as! Dictionary<String, AnyObject>
					let size = dimensions["med"] as! Array<Double>
					let imageRatio = size[0] / size[1]

					let item = Item(imageUrl: imageUrl, ratio: imageRatio)

					items.append(item)
				}

				print("Network: Fetched page \(page) (\(items.count) items)")

				completion(items)
			}
		}
	}

	func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void)
	{
		DispatchQueue.global(qos: .background).async {

			let data = try? Data(contentsOf: url)

			DispatchQueue.main.async {

				guard let data = data, let image = UIImage(data: data) else {
					completion(nil)
					return
				}

				completion(image)
			}
		}
	}
}
