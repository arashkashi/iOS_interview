//
//  MapViewRepresentable.swift
//  ArashKashi
//
//  Created by Arash Kashi on 30.01.22.
//

import Foundation
import SwiftUI
import MapKit

final class MapViewControllerRepresentable: NSObject, UIViewControllerRepresentable, MapViewControllerDelegate {
	// TODO: to be unit tested.
	/// Called when annotation on map are selected.
	/// - Parameter annotation: selected annotation.
	func onAnnotationSelected(_ annotation: POIAnnotation) {
		self.onAnnotationTapped(annotation)
	}
	// TODO: to be unit tested.
	/// Called when map region is changed.
	/// - Parameter mapView: the map which its region has changed.
	func onRegionChanged(_ mapView: MKMapView) {
		self.onMapRegionChanged(mapView)
	}
	
	/// Bindings of the points of interest.
	var pois: Binding<[POI]>
	/// Call back for when annotation is tapped.
	var onAnnotationTapped: ((POIAnnotation) -> Void)
	/// Call back for when region is changed.
	var onMapRegionChanged: ((MKMapView) -> Void)
	
	/// Map View Controller which renders a basic map view with annotation functionality.
	var mapViewController: MapViewController? = nil
	
	/// Initiation
	/// - Parameter pois: binding of POI to be observed for updates on map view annotations.
	init(pois: Binding<[POI]>,
		 onAnnotationTapped: @escaping ((POIAnnotation) -> Void),
		 onMapRegionChanged: @escaping ((MKMapView) -> Void)
	) {
		self.pois = pois
		self.onAnnotationTapped = onAnnotationTapped
		self.onMapRegionChanged = onMapRegionChanged
	}
	
	// TODO: to be unit tested.
	
	/// Convers backend POI data to map view annotations.
	/// - Parameter pois: POI data from backend.
	/// - Returns: Map annotations.
	func getAnnotations(pois: [POI]) -> [POIAnnotation] {
		let annotations: [POIAnnotation] = pois.map{ poi in
			let coordinate = CLLocationCoordinate2D(
				latitude: poi.coordinate.latitude,
				longitude: poi.coordinate.longitude
			)
			let annotation = POIAnnotation.new(coordinate, annotationId: poi.id)
			
			return annotation
		}
		return annotations
	}
	
	///
	/// You must implement this method and use it to create your view controller
	/// object. Create the view controller using your app's current data and
	/// contents of the `context` parameter. The system calls this method only
	/// once, when it creates your view controller for the first time. For all
	/// subsequent updates, the system calls the
	/// ``UIViewControllerRepresentable/updateUIViewController(_:context:)``
	/// method.
	///
	/// - Parameter context: A context structure containing information about
	///   the current state of the system.
	///
	/// - Returns: Your UIKit view controller configured with the provided
	///   information.
	func makeUIViewController(context: Context) -> MapViewController {
		let viewController = MapViewController(nibName: nil, bundle: nil)
		viewController.delegate = self
		return viewController
	}
	
	/// Updates the state of the specified view controller with new information
	/// from SwiftUI.
	///
	/// When the state of your app changes, SwiftUI updates the portions of your
	/// interface affected by those changes. SwiftUI calls this method for any
	/// changes affecting the corresponding AppKit view controller. Use this
	/// method to update the configuration of your view controller to match the
	/// new state information provided in the `context` parameter.
	///
	/// - Parameters:
	///   - uiViewController: Your custom view controller object.
	///   - context: A context structure containing information about the current
	///     state of the system.
	func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
		
		let annotations = self.getAnnotations(pois: pois.wrappedValue)
		uiViewController.addMapAnnotations(annotations)
		uiViewController.delegate = self
	}
	
	typealias UIViewControllerType = MapViewController
}



extension MKMapView {
	// TODO: the test for this part must be done later as the logic for BE, the order of p1, p2
	// are unclear at the point of development. e.g. it is not clear of rectangle should be
	// with NW, SE points or NE, SW points etc.
	
	/// For a given visible map view, it returns a two point data structure representing the two corders map view range.
	/// - Returns: coordinate of two end.
	func getTwoPointsRectCoordinate() -> TwoPointsRectCoordinate {
		
		let rect = visibleMapRect
		
		let nwPoint = MKMapPoint(x: rect.origin.x, y: rect.origin.y)
		let sePoint = MKMapPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height)

		let p1 = nwPoint.coordinate
		let p2 = sePoint.coordinate
		
		return TwoPointsRectCoordinate(p1: p1, p2: p2)
	}
}
