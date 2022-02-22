//
//  POIsView.swift
//  ArashKashi
//
//  Created by Arash Kashi on 30.01.22.
//

import SwiftUI
import Combine

struct POIsView: View {
	
	class ViewModel: ObservableObject {
		
		/// Latest fetch values of POIs.
		@Published var pois: [POI] = []
		
		/// Query of the backend is done via simply updating the query value here.
		@Published var rectCoordinateQuery: TwoPointsRectCoordinate
		
		/// Combine bag.
		var bag = Set<AnyCancellable>()
		
		init() {
			rectCoordinateQuery = TwoPointsRectCoordinate.getHamburgRect()
			
			/// When query is updated, BE call is dispatched.
			$rectCoordinateQuery.sink { rectCoordinate in
				POIService
					.shared
					.updatePublishedPOIs(squareCoordinate: rectCoordinate)
				
			}.store(in: &bag)
			
			/// When backend updates the cached value, it updates the associated views here.
			POIService.shared.$pois.sink(receiveCompletion: { completion in
				print("")
			}, receiveValue: { [weak self] result in
				switch result {
				case .success(let pois):
					self?.pois = pois
				case .failure(_):
					// TODO: Handle error gracefully. For now just show empty list.
					self?.pois = []
				}
			}).store(in: &bag)
		}
	}
	
	/// View model of points of interest view.
	@ObservedObject var viewModel: ViewModel
	
	/// Two options on this view: list view, and map view.
	@State var selectedOption = POIViewOptions.map.rawValue
	
	var body: some View {
		NavigationView {
			TabView(selection: $selectedOption) {
				VStack {
					POIMapView(pois: $viewModel.pois, viewModel: viewModel)
				}
				.tabItem {
					Label("Map", systemImage: "map")
				}
				.tag(1)
				POIListView(pois: $viewModel.pois)
					.tabItem {
						Label("List", systemImage: "list.bullet")
					}
					.tag(0)
				// VStack is a workout for know tab view issue.
			}
		}
	}
}

enum POIViewOptions: Int, CaseIterable {
	case list = 0
	case map
	
	var localized: String {
		switch self {
		case .list:
			return NSLocalizedString(
				"List",
				comment: "picker selector which appears on poi list view for list option."
			)
		case .map:
			return NSLocalizedString(
				"Map",
				comment: "picker selector which appears on poi list view for map option."
			)
		}
	}
}

struct POIsView_Previews: PreviewProvider {
	static var previews: some View {
		POIsView(viewModel: POIsView.ViewModel())
	}
}
