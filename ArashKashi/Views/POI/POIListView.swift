//
//  POIListView.swift
//  ArashKashi
//
//  Created by Arash Kashi on 29.01.22.
//

import SwiftUI

struct POIListView: View {
	
	/// This is @binding and not @state since @state does not re-render the view when superview changes.
	@Binding var pois: [POI]
	
	var body: some View {
		
		if pois.count == 0 {
			Text(NSLocalizedString("Empty List!", comment: "Empty list text."))
				.navigationTitle(NSLocalizedString("POIs", comment: "The title for the list for points of interest."))
		} else {
			List {
				ForEach(pois) { poi in
					NavigationLink(destination: POIDetailView(poi: poi)) {
						POICellView(poi: poi)
					}
				}
			}
			// TODO: Need localization to be implemented.
			.navigationTitle(NSLocalizedString("POIs", comment: "The title for the list for points of interest."))
			.refreshable {
				// TODO: Refresh logic, it is not clear upon refresh on the list view should we
				// simply repeat the same old query? also not possible to make sense for pull to refresh as for the map view it would make a lot more sense.
			}
		}
	}
}

struct POIListView_Previews: PreviewProvider {
	static var previews: some View {
		POIListView(pois: .constant(POI.getMockInstances().poiList))
	}
}
