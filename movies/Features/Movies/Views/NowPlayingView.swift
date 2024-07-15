//
//  NowPlayingView.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import SwiftUI

struct NowPlayingView: View {
    @ObservedObject var viewModel: MoviesViewModel
    @Binding var isGridView: Bool
    @Binding var searchText: String

    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.movies.isEmpty {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            } else {
                if isGridView {
                    MovieGridView(viewModel: viewModel, searchText: $searchText)
                } else {
                    MovieListView(viewModel: viewModel, searchText: $searchText)
                }
            }
        }
        .navigationTitle("Now Playing")
        .onAppear {
            viewModel.switchCategory(to: .nowPlaying)
            viewModel.fetchMovies()
        }
    }
}
