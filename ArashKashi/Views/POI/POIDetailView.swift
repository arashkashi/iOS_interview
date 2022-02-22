//
//  POIDetailView.swift
//  ArashKashi
//
//  Created by Arash Kashi on 30.01.22.
//

import SwiftUI

struct POIDetailView: View {
	@State var poi: POI
    var body: some View {
		VStack(alignment: .leading) {
			Text("id: \(poi.id)")
			Text("Type: \(poi.type.rawValue)")
			Text("State: \(poi.state.rawValue)")
			Text("Lat: \(poi.coordinate.latitude)")
			Text("Long: \(poi.coordinate.longitude)")
		}
		.navigationTitle("\(poi.id)")
    }
}

struct POIDetailView_Previews: PreviewProvider {
    static var previews: some View {
		POIDetailView(poi: POI.getMockInstances().poiList.first!)
	}
}
