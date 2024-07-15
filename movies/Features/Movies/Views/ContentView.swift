//
//  ContentView.swift
//  movies
//
//  Created by Carlos Ramos on 12/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @State private var isGridView: Bool = false
    @State private var searchText: String = ""
    @State private var selectedTab: Tab = .mostPopular

    enum Tab {
        case mostPopular
        case nowPlaying
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MostPopularView(viewModel: viewModel, isGridView: $isGridView, searchText: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isGridView.toggle()
                            }) {
                                Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Most Popular")
            }
            .tag(Tab.mostPopular)

            NavigationStack {
                NowPlayingView(viewModel: viewModel, isGridView: $isGridView, searchText: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isGridView.toggle()
                            }) {
                                Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
            }
            .tabItem {
                Image(systemName: "play.rectangle.fill")
                Text("Now Playing")
            }
            .tag(Tab.nowPlaying)
        }
        .searchable(text: $searchText, prompt: "Search movies")

    }
}
