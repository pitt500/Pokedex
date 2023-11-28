import Combine
import Foundation

enum PokemonError: Error {
    case serverError
    case noData
}

/*
 This source file is part of https://github.com/pitt500/Pokedex/

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

class PokemonLoader: ObservableObject {
    @Published private(set) var pokemonData: [Pokemon] = []

    private let urlSession = URLSession(configuration: .default)
    private let limit = 10
    private var offset = 0

    func restartPagination() {
        offset = 0
        Pokemon.totalFound = 0
    }


    private func getPokemons() async throws -> [Pokemon] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)&offset=\(offset)")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200
        else { throw PokemonError.serverError }

        guard let decoded = try? JSONDecoder().decode(PokemonResponse.self, from: data)
        else { throw PokemonError.noData }

        self.offset += self.limit

        return decoded.results
    }

    @MainActor func load(restart: Bool = false) async {
        if restart {
            restartPagination()
            pokemonData.removeAll()
        }

        do {
            pokemonData += try await getPokemons()
        } catch {
            print("error: ",error)
        }
    }
}



