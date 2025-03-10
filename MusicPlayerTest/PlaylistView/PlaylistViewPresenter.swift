//
//  PlaylistViewPresenter.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 10.03.2025.
//

import Foundation

protocol PlaylistViewRouter: NavigationStackRouter { }

protocol PlaylistViewInteractorProtocol {
    func play()
    func next()
    func prev()
    func seek(to time: Double)
}

class PlaylistViewPresenter: PlaylistViewPresenterProtocol {
    
    var router: PlaylistViewRouter?
    var interactor: PlaylistViewInteractorProtocol?
    
    @Published var tracks: [TrackInfo] = []
    
    func presentBackAction() {
        router?.backInNavigation()
    }
    
    func play() {
        interactor?.play()
    }
    
    func next() {
        interactor?.next()
    }
    
    func prev() {
        interactor?.prev()
    }
    
    func seek(to time: Double) {
        interactor?.seek(to: time)
    }
    
}
