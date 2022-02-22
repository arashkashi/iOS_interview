//
//  POICellView.swift
//  ArashKashi
//
//  Created by Arash Kashi on 30.01.22.
//

import SwiftUI

struct POICellView: View {
	@State var poi: POI
    var body: some View {
		HStack {
			Image(systemName: "arrow.down")
				.foregroundColor(poi.state == .active ? .green : .red)
				.rotationEffect(.degrees(poi.heading))
			VStack(alignment: .leading) {
				Text("\(poi.type.rawValue)")
					.font(.caption)
					.foregroundColor(Color.gray)
				Text("id: \(poi.id)")
					.font(.caption2)
			}
		}
    }
}

struct POICellView_Previews: PreviewProvider {
    static var previews: some View {
		POICellView(poi: POI.getMockInstances().poiList.first!)
    }
}
