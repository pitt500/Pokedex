import Combine
import Foundation

enum PokemonError: Error, Identifiable {
    case serverError
    case noData

    var id: Self {
        self
    }
}

class PokemonLoader: ObservableObject {
    @Published var pokemonData: [Pokemon] = []
    @Published var error = false

    private let urlSession = URLSession(configuration: .default)
    private let limit = 5
    private var offset = 0

    func asyncLoad() async throws {
        offset = 0
        Pokemon.totalFound = 0
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)&offset=\(offset)")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200
        else { throw PokemonError.serverError }

        guard let decoded = try? JSONDecoder().decode(PokemonResponse.self, from: data)
        else { throw PokemonError.noData }

        await updateList(newData: decoded.results)
    }

    @MainActor func updateList(newData: [Pokemon]) {
        print(newData.map(\.name))
        self.pokemonData = newData
        self.offset += self.limit
    }


    func getMorePokemons() async -> [Pokemon] {
        self.offset += self.limit
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)&offset=\(offset)")!
        guard let (data, response) = try? await URLSession.shared.data(from: url)
        else { return [] }

        guard (response as? HTTPURLResponse)?.statusCode == 200
        else { return [] }

        guard let decoded = try? JSONDecoder().decode(PokemonResponse.self, from: data)
        else { return [] }

        return decoded.results
    }

    func load() async {
        do {
            try await asyncLoad()
        } catch {
            print(error)
            self.error = true
        }
    }
}



