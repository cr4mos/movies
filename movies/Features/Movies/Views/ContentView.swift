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
                Picker("Category", selection: $viewModel.selectedCategory) {
                    ForEach(MoviesViewModel.MovieCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: viewModel.selectedCategory) { newCategory in
                    viewModel.switchCategory(to: newCategory)
                }

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
                        MovieGridView(viewModel: viewModel)
                    } else {
                        MovieListView(viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Movies")
            .onAppear {
                viewModel.fetchMovies()
            }
        }
    }
}
