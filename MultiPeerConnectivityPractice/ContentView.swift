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
//            Text(viewModel.numberLabel)
//                .font(.largeTitle)

            Button("Click") {
                viewModel.didTappedClickButton()
            }
            .font(.largeTitle)

            Button("Hosting") {
                viewModel.startHosting()
            }
            .font(.largeTitle)

            Button("Join") {
                viewModel.joinSession()
            }
            .font(.largeTitle)
        }
    }
}
