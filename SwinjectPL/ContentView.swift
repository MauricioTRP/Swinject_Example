//
//  ContentView.swift
//  SwinjectPL
//
//  Created by Mauricio Fuentes Bravo on 11-11-25.
//

import SwiftUI
import Swinject

struct ContentView: View {
    
    @State var viewModel: ViewModel
    
    var body: some View {
        VStack {
            List(viewModel.posts) { post in
                Text(post.title)
            }
        }
        .padding()
    }
}

#Preview {
    let previewAssembler = Assembler([
        NetworkAssembly(),
        LocalDataAssembly(),
        RepositoryAssembly(),
        ViewModelAssembly()
    ])

    let resolver = previewAssembler.resolver
    return ContentView(
        viewModel: resolver.resolve(ViewModel.self)!
    )
}
