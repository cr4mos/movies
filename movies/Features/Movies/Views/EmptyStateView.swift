//
//  EmptyStateView.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    let emoji: String

    var body: some View {
        VStack {
            Text(emoji)
                .font(.system(size: 64))
            Text(message)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}
