import SwiftUI

struct PokemonList: View {
    @ObservedObject var loader: PokemonLoader

    var body: some View {

        // Using ScrollView, you cannot use refreshable modifier.
        // or swipe actions
        ScrollView {
            //Change this to VStack and see what happen!
            LazyVStack {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList(loader: PokemonLoader())
    }
}
