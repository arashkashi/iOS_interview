//
//  POI+URLRequest.swift
//  ArashKashi
//
//  Created by Arash Kashi on 31.01.22.
//

import Foundation


extension POI {
	enum `URLRequest` {
		case fetch(p1Lat: Double, p1Lon: Double, p2Lat: Double, p2Lon: Double)
		
		var path: String {
			return "/PoiService/poi/v1"
		}
		
		func getBaseURLComponent() -> URLComponents {
			var components = URLComponents()
			components.scheme = currentEnvironment.scheme
			components.host = currentEnvironment.host
			components.path = self.path
			return components
		}

		func get() -> URL {
			var components = getBaseURLComponent()
			switch self {
			case .fetch(let p1Lat, let p1Lon, let p2Lat, let p2Lon):
				components.queryItems = [
					URLQueryItem(name: "p1Lat", value: "\(p1Lat)"),
					URLQueryItem(name: "p2Lat", value: "\(p2Lat)"),
					URLQueryItem(name: "p1Lon", value: "\(p1Lon)"),
					URLQueryItem(name: "p2Lon", value: "\(p2Lon)")
				]
			}
			// Use forced unwrap since the operation is deterministic.
			return components.url!
		}
		
		func get() -> Foundation.URLRequest {
			return Foundation.URLRequest(url: self.get(),
							  cachePolicy: .reloadIgnoringLocalCacheData,
							  timeoutInterval: 200)
		}
	}
}
