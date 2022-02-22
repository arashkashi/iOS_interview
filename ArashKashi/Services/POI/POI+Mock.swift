//
//  POI+Mock.swift
//  ArashKashi
//
//  Created by Arash Kashi on 29.01.22.
//

import Foundation

extension POI {
	
	static func getMockData() throws -> Data {
		// Forced unwrapped since the operation is deterministic.
		return POI.getMockJSONString().data(using: .utf8)!
	}
	
	static func getMockJSONString() -> String {
		let path = Bundle.main.path(forResource: "POI+MockJson", ofType: "json")!
		// Forced unwrapped since the operation is deterministic.
		return try! String(contentsOfFile: path)
	}
	
	static func getMockInstances() -> POIList {
		// Forced unwrapped since the operation is deterministic.
		return try! JSONDecoder().decode(POIList.self, from: POI.getMockData())
	}
}
