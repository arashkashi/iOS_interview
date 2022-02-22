//
//  POIService.swift
//  ArashKashi
//
//  Created by Arash Kashi on 01.02.22.
//

import Foundation
import SwiftUI

class POIService: ObservableObject {
	
	static var shared: POIService = {
		return POIService()
	}()
	
	fileprivate init() {}
	
	@Published var pois: Result<[POI], Network._Error> = .success([])
	
	/// Fetches the POIs items from the BE and updates the observed publisher.
	/// - Parameter squareCoordinate: holds two corners of coordinations for search to shape a rectangle.
	func updatePublishedPOIs(squareCoordinate: TwoPointsRectCoordinate) {
		let urlRequest: Foundation.URLRequest = POI.URLRequest
			.fetch(p1Lat: squareCoordinate.p1.latitude,
				   p1Lon: squareCoordinate.p1.longitude,
				   p2Lat: squareCoordinate.p2.latitude,
				   p2Lon: squareCoordinate.p2.longitude)
			.get()
		
		Network
			.sendRequest(urlRequest: urlRequest)
		{ [weak self] (result: Result<(result: POIList, httpRes: HTTPURLResponse), Network._Error>) -> () in
			switch result {
			case .success(let success):
				self?.pois = .success(success.result.poiList)
			case .failure(let error):
				// TODO: Handle the error properly by showing error banners to user etc.
				self?.pois = .failure(error)
				break;
			}
		}
	}
}

extension Array where Element == MKMapPoint {
	
	/// Given a set of points on map, this function creates and map on rectangle.
	/// - Returns: map rectangle.
	func getRect() -> MKMapRect {
		var unionRect: MKMapRect = MKMapRect.null
		
		for point in self {
			// TODO: 0.01 value are arbitrary selected and need to be adjusted.
			let pointRect = MKMapRect(x: point.x, y: point.y, width: 0.01, height: 0.01);
			unionRect = unionRect.union(pointRect)
		}
		
		return unionRect
	}
}

struct TwoPointsRectCoordinate {

	var p1: CLLocationCoordinate2D
	var p2: CLLocationCoordinate2D
	
	/// Default query for around city of Hamburg.
	/// - Returns: Hamburg coordinates query.
	static func getHamburgRect() -> TwoPointsRectCoordinate {
		
		let p1 = CLLocationCoordinate2D(latitude: 53.694865, longitude: 9.757589)
		let p2 = CLLocationCoordinate2D(latitude: 53.394655, longitude: 10.099891)
		return TwoPointsRectCoordinate(p1: p1, p2: p2)
	}
	
	/// Return map rectangle covered by the p1 and p2 as two ends of a rectangle.
	/// - Returns: returned rectangle.
	func getMapRect() -> MKMapRect {
		// TODO: To be unit tested.
		let p1Point = MKMapPoint(CLLocationCoordinate2D(latitude: p1.latitude, longitude: p1.longitude))
		let p2Point = MKMapPoint(CLLocationCoordinate2D(latitude: p1.latitude, longitude: p2.longitude))
		return [p1Point, p2Point].getRect()
	}
	
	func getCoordinateRegion() -> MKCoordinateRegion {
		let rect = self.getMapRect()
		return MKCoordinateRegion(rect)
	}
}
