//
//  ContentView.swift
//  MultiPeerConnectivityPractice
//
//  Created by Kim Insub on 2022/09/26.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: ContentViewModel

    init() {
        viewModel = ContentViewModel()
    }

    var body: some View {
        VStack {
            Button("Advertise") {
                viewModel.advertise()
            }
            .font(.largeTitle)
            Button("Invite") {
                viewModel.invite()
            }
            .font(.largeTitle)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
