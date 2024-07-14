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

    var body: some View {
        NavigationView {
            VStack {
                Picker("View Style", selection: $isGridView) {
                    Text("List").tag(false)
                    Text("Grid").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                } else {
                    if isGridView {
                        gridView
                    } else {
                        listView
                    }
                }
            }
            .navigationTitle("Most Popular Movies")
            .onAppear {
                viewModel.fetchMostPopularMovies()
            }
        }
    }

    private var listView: some View {
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

    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
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
            }
            .padding()
        }
    }
}

