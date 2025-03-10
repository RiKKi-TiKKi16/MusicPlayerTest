//
//  SearchViewBuilder.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 08.03.2025.
//

import Foundation
import SwiftUICore

class SearchViewBuilder<Player: PlayerService>: ViewBuildable where Player.Track == TrackInfo, Player.MediaInfo.Track == Player.Track {
    
    let presenter = SearchViewPresenter()
    let playerService: Player
    
    init(router: SearchViewRouter, playerService: Player) {
        
        self.playerService = playerService
        
        presenter.router = router
        
        let searchService = ItunesNetworkService(requestBuilder: DefaultItunesRequestBuilder())
        
        let interactor = SearchViewInteractor(dependencies: .init(searchService: searchService,
                                                                 playerService: playerService))
        
        interactor.presenter = presenter
        
        presenter.interactor = interactor
    }
    
    var view: AnyView {        
        let view = SearchView(presenter: self.presenter,
                              mediaInfo: self.playerService.mediaInfo)
        
        return AnyView(view)
    }
}
