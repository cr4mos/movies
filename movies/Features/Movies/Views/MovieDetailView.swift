//
//  MovieDetailView.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let backdropPath = movie.backdropPath {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.gray
                            .frame(height: 200)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(movie.genresDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Overview")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.secondary)

                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Vote Average: \(movie.voteAverage, specifier: "%.1f")")
                        Spacer()
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.blue)
                        Text("Popularity: \(Int(movie.popularity))")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.red)
                        Text("Release Date: \(formattedDate(movie.releaseDate))")
                        Spacer()
                        Image(systemName: "globe")
                            .foregroundColor(.green)
                        Text("Language: \(movie.originalLanguage.uppercased())")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
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
