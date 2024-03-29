/*
 This source file is part of https://github.com/pitt500/Pokedex/

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

import SwiftUI

struct ErrorView: View {
    let error: Error

    var body: some View {
        print(error)
        return Text("❌ **Error**").font(.system(size: 60))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: PokemonError.noData)
    }
}
