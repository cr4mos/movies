//
//  MovieGridView.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import SwiftUI

struct MovieGridView: View {
    @ObservedObject var viewModel: MoviesViewModel
    @Binding var searchText: String

    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return viewModel.movies
        } else {
            return viewModel.movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [adaptiveGridItem()], spacing: 16) {
                ForEach(filteredMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let posterPath = movie.posterPath {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 150, height: 225)
                                }
                            } else {
                                Color.gray
                                    .frame(height: 225)
                                    .cornerRadius(8)
                            }

                            MovieDetailsView(movie: movie)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(8)
                        .shadow(radius: 4)
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
                    .padding()
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }

    private func adaptiveGridItem() -> GridItem {
        return GridItem(.adaptive(minimum: 150), spacing: 16)
    }
}
