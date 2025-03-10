//
//  SearchViewInteractor.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 09.03.2025.
//

import Foundation
import UIKit.UIImage

protocol TrackSearchService {
    func search(text: String) async throws -> [TrackInfo]
}

protocol SearchViewInteractorOutput: AnyObject {
    func presentTracks(_ tracks: [TrackInfo])
    func presentError(_ error: Error)
}

class SearchViewInteractor<Player: PlayerService>: SearchViewInteractorProtocol where Player.Track == TrackInfo {
    
    struct Dependencies {
        let searchService: TrackSearchService
        let playerService: Player
    }
    
    let dependencies: Dependencies
    weak var presenter: SearchViewInteractorOutput?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func search(text: String) {
        Task {
            do {
                let tracks = try await dependencies.searchService.search(text: text)
                
                await MainActor.run {
                    presenter?.presentTracks(filteredTracks(tracks))
                }
                
            } catch {
                presenter?.presentError(error)
            }
        }
    }
    
    func playPlaylist(_ tracks: [TrackInfo]) {
        dependencies.playerService.playQueue(tracks)
    }
    
    private func filteredTracks(_ tracks: [TrackInfo]) -> [TrackInfo] {
        
        tracks.filter { track in
            guard track.previewUrl != nil else { return false }
            return true
        }
        
    }
    
}

extension TrackInfo: PlayableItem {
    var url: URL {
        URL(string: previewUrl!)!
    }
}
