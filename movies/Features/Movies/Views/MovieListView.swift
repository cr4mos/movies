//
//  MovieListView.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import SwiftUI

struct MovieListView: View {
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
            LazyVStack {
                ForEach(filteredMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        HStack(alignment: .top, spacing: 16) {
                            if let posterPath = movie.posterPath {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 100, height: 150)
                                }
                            } else {
                                Color.gray
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text(movie.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                Text(movie.genresDescription)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("\(movie.voteAverage, specifier: "%.1f")")
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                HStack {
                                    Image(systemName: "chart.bar.fill")
                                        .foregroundColor(.blue)
                                    Text("\(Int(movie.popularity))")
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.red)
                                    Text(formattedDate(movie.releaseDate))
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                            .padding(.trailing)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    }
                    .padding([.horizontal, .top])
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
        }
        .background(Color(.systemBackground))
    }

    private func formattedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}
