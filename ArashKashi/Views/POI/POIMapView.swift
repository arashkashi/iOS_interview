//
//  POIMapView.swift
//  ArashKashi
//
//  Created by Arash Kashi on 30.01.22.
//

import SwiftUI

struct POIMapView: View {
	
	@Binding var pois: [POI]
	// For now just have a dummy, none optional value to begin so navigation link
	// could function properly.
	@State var selectedPOI: POI = POI.getMockInstances().poiList.first!
	@State var shouldShowDetailPOI: Bool = false
	
	@ObservedObject var viewModel: POIsView.ViewModel
	
    var body: some View {
		
		MapViewControllerRepresentable(pois: $pois) { selectedAnnotation in
			let poi = pois.first { poi in
				poi.id == selectedAnnotation.annotationId
			}
			if let validPOI = poi {
				selectedPOI = validPOI
				shouldShowDetailPOI = true
			}
		} onMapRegionChanged: { mapView in
			viewModel
				.rectCoordinateQuery = mapView.getTwoPointsRectCoordinate()

		}
		.cornerRadius(8.0)
		.shadow(color: .gray, radius: 16, x: 0, y: 0)
		.padding()
		
		.navigationTitle(NSLocalizedString("POIs", comment: "Title of map view for POIs"))
		NavigationLink("", destination: POIDetailView(poi: selectedPOI), isActive: $shouldShowDetailPOI)
    }
}

struct POIMapView_Previews: PreviewProvider {
    static var previews: some View {
		POIMapView(pois: .constant(POI.getMockInstances().poiList), viewModel: POIsView.ViewModel())
    }
}
