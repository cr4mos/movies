//
//  MovieListView.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MoviesViewModel

    var body: some View {
        List {
            ForEach(viewModel.movies) { movie in
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                    Text(movie.overview)
                        .font(.subheadline)
                }
                .onAppear {
                    viewModel.loadMoreMoviesIfNeeded(currentMovie: movie)
                }
            }

            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
}

