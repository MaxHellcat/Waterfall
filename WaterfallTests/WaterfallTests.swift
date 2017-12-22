//
//  WaterfallTests.swift
//  WaterfallTests
//
//  Created by Max Reshetey on 22/12/2017.
//  Copyright © 2017 Max Reshetey. All rights reserved.
//

import XCTest
@testable import Waterfall

class WaterfallTests: XCTestCase
{
	// More tests can be added, showing here the basic one
    func testFetchingMetadata()
	{
		let networkManager = NetworkManager()

		networkManager.fetchNextPage() { [weak self] items in

			XCTAssert(items != nil && items!.count > 0)
		}
    }
}
