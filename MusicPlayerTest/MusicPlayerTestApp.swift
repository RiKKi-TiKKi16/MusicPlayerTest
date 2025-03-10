//
//  MusicPlayerTestApp.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 06.03.2025.
//

import SwiftUI

@main
struct MusicPlayerTestApp: App {
    @ObservedObject var router = MainRouter()
    let assambler = ModuleAssambler()
    
    init() {
        router.assambler = assambler
        assambler.router = router
    }
    
    var body: some Scene {
        WindowGroup {
            RouterView(routes: $router.routes) {
                assambler.makeStartModule().body
            }
        }
    }
}
