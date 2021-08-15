import SwiftUI

struct PokemonList: View {
    @ObservedObject var loader: PokemonLoader

    var body: some View {
        List {
            ForEach(loader.pokemonData) { pokemon in
                PokemonCell(pokemon: pokemon, loader: loader)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList(loader: PokemonLoader())
    }
}
