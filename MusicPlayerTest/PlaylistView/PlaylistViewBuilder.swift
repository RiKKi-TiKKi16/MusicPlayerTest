//
//  PlaylistViewBuilder.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 08.03.2025.
//

import Foundation
import SwiftUICore

class PlaylistViewBuilder<Player: PlayerService>: ViewBuildable where Player.Track == TrackInfo, Player.MediaInfo.Track == Player.Track {
    
    let presenter = PlaylistViewPresenter()
    let playerService: Player
    
    init(router: PlaylistViewRouter, playerService: Player) {
        
        self.playerService = playerService
        presenter.tracks = playerService.tracks
        
        presenter.router = router
        
        let interactor = PlaylistViewInteractor(dependencies: .init(playerService: playerService))
        presenter.interactor = interactor
        
    }
    
    var view: AnyView {
        let view = PlaylistView(presenter: self.presenter,
                                mediaInfo: self.playerService.mediaInfo)
        return AnyView(view)
    }
}
