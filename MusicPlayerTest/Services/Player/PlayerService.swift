//
//  PlayerService.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 09.03.2025.
//

import Foundation
import MediaPlayer
import Combine

protocol PlayableItem: Equatable {
    var url: URL { get }
}

protocol PlayerServiceMediaInfo: AnyObject, ObservableObject {
    associatedtype Track: PlayableItem
    var played: Track? { get }
    var isPlaying: Bool { get }
    var curTime: Double { get }
    var duration: Double { get }
}

protocol PlayerService {
    associatedtype Track: PlayableItem
    associatedtype MediaInfo: PlayerServiceMediaInfo
    
    var mediaInfo: MediaInfo { get }
    
    var tracks: [Track] { get }
    func playQueue(_ tracks: [Track])
    
    func play()
    func pause()
    func next()
    func previus()
    func seek(to time: Double)
}

class DefaultPlayerService<Track: PlayableItem>: PlayerService {
    
    class MediaInfo: PlayerServiceMediaInfo {
        @Published var played: Track?
        @Published var isPlaying: Bool = false
        @Published var curTime: Double = 0
        @Published var duration: Double = 0
    }
    
    let mediaInfo: MediaInfo = .init()
    
    private let core: any AudioPlayerCore
    private let _mediaInfo = MediaInfo()
    private var bag = Set<AnyCancellable>()
    
    private(set) var tracks: [Track] = []
    
    init(core: any AudioPlayerCore = CorePlayerService()) {
        self.core = core
        
        core.stateUpdate
            .receive(on: DispatchQueue.main)
            .sink {[weak self] coreState in
                
                if let url = coreState.playedUrl {
                    self?.mediaInfo.played = self?.tracks.first(where: { $0.url == url })
                }
                
                self?.mediaInfo.isPlaying = coreState.isPlaying
                self?.mediaInfo.curTime = coreState.curTime
                self?.mediaInfo.duration = coreState.duration
                
            }.store(in: &bag)
        
    }
    
    func play() {
        core.play()
    }
    
    func pause() {
        core.pause()
    }
    
    func next() {
        core.next()
    }
    
    func previus() {
        core.previus()
    }
    
    func playQueue(_ tracks: [Track]) {
        self.tracks = tracks
        let urls = tracks.map({ $0.url })
        core.setupQueue(tracks: urls)
    }
    
    func seek(to time: Double) {
        core.seek(to: time)
    }
}
