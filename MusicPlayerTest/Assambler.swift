//
//  Assambler.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 08.03.2025.
//

import Foundation
import SwiftUICore

protocol ViewBuildable {
    var view: AnyView { get }
}

struct Module: Hashable {
    static func == (lhs: Module, rhs: Module) -> Bool {
        lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    private let uid = UUID()
    let builder: any ViewBuildable
    
    @ViewBuilder var body: some View {
        builder.view
    }
    
}

extension ModuleAssambler {
    typealias Router = SearchViewRouter & PlaylistViewRouter
}
 
class ModuleAssambler: ModuleAssembly {
    
    var router: Router!
    let audioPlayer = DefaultPlayerService<TrackInfo>()
    
    func makeStartModule() -> Module {
        .init(builder: SearchViewBuilder(router: router,
                                        playerService: audioPlayer))
    }
    
    func makePlaylistModule() -> Module {
        .init(builder: PlaylistViewBuilder(router: router,
                                           playerService: audioPlayer))
    }
}
