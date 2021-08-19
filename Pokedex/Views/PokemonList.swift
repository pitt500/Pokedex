import SwiftUI

struct PokemonList: View {
    @ObservedObject var loader: PokemonLoader

    var body: some View {
        List {
            ForEach(loader.pokemonData) { pokemon in
                PokemonCell(pokemon: pokemon)
                .task {
                    if pokemon == loader.pokemonData.last {
                        await loader.load()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList(loader: PokemonLoader())
    }
}
