//
//  PokemonCell.swift
//  PokemonCell
//
//  Created by Pedro Rojas on 15/08/21.
//

import SwiftUI

struct PokemonCell: View {
    let pokemon: Pokemon
    private let imageWidth = 110.0
    private let cellHeight = 130.0

    var body: some View {
        AsyncImage(
            url: pokemon.url
        ) { phase in
            switch phase {
            case .success(let image):
                HStack {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageWidth)
                        .padding(.trailing, 10)
                    PokemonDescriptionView(pokemon: pokemon)
                    Spacer()
                }
            case .failure(let error):
                ErrorView(error: error)
            case .empty:
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                    Spacer()
                }
            @unknown default:
                // AsyncImagePhase is not marked as @frozen.
                // We need to support new cases in the future.
                Image(systemName: "questionmark")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: cellHeight)
        .padding()
        .listRowSeparator(.hidden)
    }
}

struct PokemonCell_Previews: PreviewProvider {
    static var previews: some View {
        PokemonCell(pokemon: Pokemon.sample)
    }
}


