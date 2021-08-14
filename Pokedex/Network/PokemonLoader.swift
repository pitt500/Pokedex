import Combine
import Foundation

enum PokemonError: Error {
    case serverError
    case noData
}

class PokemonLoader: ObservableObject {
    @Published private(set) var pokemonData: [Pokemon] = []
    @Published var error = false

    private let urlSession = URLSession(configuration: .default)
    private let limit = 5
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

        //print(decoded.results.map(\.name))
        return decoded.results
    }

    @MainActor func loadMorePokemons() async {
        do {
            pokemonData += try await getPokemons()
        } catch {
            print("error: ",error)
            self.error = true
        }
    }

    @MainActor func load() async {
        restartPagination()

        do {
            pokemonData = try await getPokemons()
        } catch {
            print("error: ",error)
            self.error = true
        }
    }
}



