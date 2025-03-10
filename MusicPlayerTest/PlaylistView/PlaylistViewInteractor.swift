//
//  PlaylistViewInteractor.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 10.03.2025.
//

import Foundation

class PlaylistViewInteractor<Player: PlayerService>: PlaylistViewInteractorProtocol where Player.Track == TrackInfo {
    
    struct Dependencies {
        let playerService: Player
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func play() {
        if dependencies.playerService.mediaInfo.isPlaying {
            dependencies.playerService.pause()
        } else {
            dependencies.playerService.play()
        }
    }
    
    func next() {
        dependencies.playerService.next()
    }
    
    func prev() {
        dependencies.playerService.previus()
    }
    
    func seek(to time: Double) {
        dependencies.playerService.seek(to: time)
    }
}
