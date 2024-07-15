//
//  MovieDetailsView.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import SwiftUI

struct MovieDetailsView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
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
                Text(DateFormatterHelper.formattedDate(movie.releaseDate))
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }
}


struct DateFormatterHelper {
    static func formattedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}
