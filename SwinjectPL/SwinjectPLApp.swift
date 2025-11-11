//
//  SwinjectPLApp.swift
//  SwinjectPL
//
//  Created by Mauricio Fuentes Bravo on 11-11-25.
//

import SwiftUI
import Swinject

@main
struct SwinjectPLApp: App {
    private let assembler = Assembler([
        NetworkAssembly(),
        LocalDataAssembly(),
        RepositoryAssembly(),
        ViewModelAssembly()
    ])
    
    var body: some Scene {
        WindowGroup {
            RootView(assembler: assembler)
        }
    }
}

struct RootView : View {
    let assembler: Assembler
    
    var body: some View {
        ContentView(viewModel: assembler.resolver.resolve(ViewModel.self)!)
            .environment(\.resolver, assembler.resolver)
    }
}

private struct ResolverKey: EnvironmentKey {
    static let defaultValue: Resolver = Assembler().resolver
}

extension EnvironmentValues {
    var resolver: Resolver {
        get { self[ResolverKey.self] }
        set{ self[ResolverKey.self] = newValue }
    }
}
