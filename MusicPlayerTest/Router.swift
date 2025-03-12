//
//  Router.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 08.03.2025.
//

import SwiftUI

struct RouterView<Content: View>: View {
    
    @Binding var routes: [Module]
    @ViewBuilder private let rootView: () -> Content
    
    init(routes: Binding<[Module]>, @ViewBuilder content: @escaping () -> Content) {
        self.rootView = content
        self._routes = routes
    }

    var body: some View {
        NavigationStack(path: $routes) {
            rootView()
                .navigationDestination(for: Module.self) { module in
                    module.body
                }
        }
    }
}

protocol ModuleAssembly {
    func makeStartModule() -> Module
    func makePlaylistModule() -> Module
}

protocol NavigationStackRouter {
    func backInNavigation()
}

class MainRouter: ObservableObject {
    
    @Published var routes = [Module]()
    var assambler: ModuleAssembly!
    
    func pushModule(_ module: Module) {
        routes.append(module)
    }
    
    func popModule() {
        _ = routes.popLast()
    }
}

extension MainRouter: NavigationStackRouter {
    func backInNavigation() {
        popModule()
    }
}

extension MainRouter: SearchViewRouter {
    func routeToPlaylist() {
        pushModule(assambler.makePlaylistModule())
    }
}

extension MainRouter: PlaylistViewRouter { }
