/*
 This source file is part of https://github.com/pitt500/Pokedex/

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

import SwiftUI

struct PokedexView: View {
    @StateObject private var loader = PokemonLoader()

    var body: some View {
        NavigationView {
            PokemonList(loader: loader)
            .navigationTitle("PokeDex")
            .task {
                // Task is the same like onAppear, but works with async tasks.
                // also it cancels the task when the view disappears.
                await loader.load(restart: true)
            }
            .refreshable {
                // Enable Pull to refresh
                await loader.load(restart: true)
            }
        }

    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}
