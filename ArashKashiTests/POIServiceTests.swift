//
//  POIServiceTests.swift
//  ArashKashiTests
//
//  Created by Arash Kashi on 29.01.22.
//

import XCTest
@testable import ArashKashi

class POIServiceTests: XCTestCase {

	// Test if the POI list is parsed correctly.
    func testPOIListParse() throws {
		let pois = POI.getMockInstances()
		XCTAssert(pois.poiList.count == 154)
		XCTAssert(pois.poiList.first?.type == .taxi)
		XCTAssert(pois.poiList.first?.state == .active)
		
		XCTAssert(pois.poiList.first?.id == -561612489)
		XCTAssert(pois.poiList.first?.coordinate.latitude == 53.54806509509537)
		XCTAssert(pois.poiList.first?.coordinate.longitude == 10.006804838776588)
		XCTAssert(pois.poiList.first?.heading == 273.58962754505694)
		
		// TODO: Check other items of the list as necessary.
    }
	
	func testPOIServiceCall() throws {
		let expectation = expectation(description: "Wait for BE call")
		
		let urlRequest: Foundation.URLRequest = POI.URLRequest
			.fetch(p1Lat: 53.694865,
				   p1Lon: 9.757589,
				   p2Lat: 53.394655,
				   p2Lon: 10.099891)
			.get()
		
		Network.sendRequest(urlRequest: urlRequest)
		{ (result: Result<(result: POIList, httpRes: HTTPURLResponse), Network._Error>) -> () in
			switch result {
			case .success(let success):
				// TODO: make other tests to make sure the data is correct.
				// Unless we have environments such as "mock" or "development" for
				// fixed responses. Hence here we just check for the call returning
				// 200 without error but can not check on the content of response.
				XCTAssert(success.httpRes.statusCode == 200)
				// TODO: this assertion is marginally true since there could be no result
				// assuming this end point is a test end point and always return something
				// for the sake of this test, hence assertion is done.
				XCTAssertTrue(success.result.poiList.count > 0)
			case .failure(_):
				XCTAssert(false)
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 3, handler: nil)
	}
}

