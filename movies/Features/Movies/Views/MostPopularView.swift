//
//  MostPopularView.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import SwiftUI

struct MostPopularView: View {
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
        .navigationTitle("Most Popular")
        .onAppear {
            viewModel.switchCategory(to: .mostPopular)
            viewModel.fetchMovies()
        }
    }
}
