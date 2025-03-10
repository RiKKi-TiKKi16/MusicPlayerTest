//
//  SearchViewPresenter.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 08.03.2025.
//

import Foundation
import Combine
import UIKit.UIImage

protocol SearchViewRouter {
    func routeToPlaylist()
}

protocol SearchViewInteractorProtocol {
    func search(text: String)
    func playPlaylist(_ tracks: [TrackInfo])
}

class SearchViewPresenter: SearchViewPresenterProtocol {
    
    @Published var searchString = String()
    @Published var tracks = [TrackInfo]()
    
    var router: SearchViewRouter?
    var interactor: SearchViewInteractorProtocol?
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        $searchString
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .filter({ !$0.isEmpty })
            .sink(receiveValue: {[weak self] value in
                self?.interactor?.search(text: value)
            })
            .store(in: &bag)
    }
    
    func playTrack(_ track: TrackInfo) {
        
        guard let trackIndex = tracks.firstIndex(of: track) else { return }
        
        var playlist = tracks[trackIndex ..< tracks.count]
        playlist.append(contentsOf: tracks[0 ..< trackIndex])
        
        interactor?.playPlaylist(Array(playlist))
        
        router?.routeToPlaylist()
    }

}

extension SearchViewPresenter: SearchViewInteractorOutput {
    
    func presentTracks(_ tracks: [TrackInfo]) {
        self.tracks = tracks
    }
    
    func presentError(_ error: any Error) {
        print(error)
    }
}
