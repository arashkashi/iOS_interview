//
//  POI+Model.swift
//  ArashKashi
//
//  Created by Arash Kashi on 28.01.22.
//

import Foundation
import CoreLocation

public struct POI: Codable, Identifiable {
	
	enum State: String, Codable {
		case active = "ACTIVE"
		case inactive = "INACTIVE"
	}

	enum `Type`: String, Codable {
		case taxi = "TAXI"
	}
	
	struct Coordinate: Codable {
		let latitude: CLLocationDegrees
		let longitude: CLLocationDegrees
	}
	
	public let id: Int
	let coordinate: Coordinate
	let state: State
	let type: `Type`
	let heading: Double
}

struct POIList: Codable {
	let poiList: [POI]
}




