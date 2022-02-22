//
//  ContentView.swift
//  ArashKashi
//
//  Created by Arash Kashi on 28.01.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		POIsView(viewModel: POIsView.ViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
