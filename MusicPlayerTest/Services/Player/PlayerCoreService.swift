//
//  PlayerService.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 09.03.2025.
//

import Foundation
import Combine
import AVFoundation

protocol AudioPlayerCore {
    var state: any CorePlayerState { get }
    var stateUpdate: AnyPublisher<any CorePlayerState, Never> { get }
    func setupQueue(tracks: [URL])
    func play()
    func pause()
    func next()
    func previus()
    func seek(to time: Double)
}

protocol CorePlayerState {
    var playedUrl: URL? { get }
    var isPlaying: Bool { get }
    var curTime: Double { get }
    var duration: Double { get }
}

class CorePlayerService {
    
    class DefaultState: CorePlayerState, ObservableObject {
        @Published var playedUrl: URL?
        @Published var isPlaying: Bool = false
        @Published var curTime: Double = 0
        @Published var duration: Double = 0
    }
    
    private let audioSession: AVAudioSession
    private let queuePlayer: AVQueuePlayer
    private var timeObserver: Any?
    private var stopObserving = false
    @Published private var _state: DefaultState
    
    private var playerItems = [AVPlayerItem]()
    var playlist: [URL] = []
    
    init() {
        audioSession = .sharedInstance()
        queuePlayer = .init(items: [])
        _state = DefaultState()
        try? audioSession.setCategory(.playback)
        addStateObserver()
    }
    
    private func setupQueue() {
        
        queuePlayer.removeAllItems()
        playerItems.removeAll()
        
        for url in playlist {
            let item = AVPlayerItem(url: url)
            playerItems.append(item)
            queuePlayer.insert(item, after: nil)
        }
        
        play()
    }
    
    func play() {
        _state.isPlaying = true
        try? audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        queuePlayer.play()
    }
    
    func pause() {
        _state.isPlaying = false
        try? audioSession.setActive(false, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        queuePlayer.pause()
    }
    
    func nextTrack() {
        try? audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        queuePlayer.advanceToNextItem()
    }
    
    private func addStateObserver() {
        timeObserver = queuePlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .global()) { [weak self] time in
            
            guard let currItem = self?.queuePlayer.currentItem else { return }
            
            if let indexItem = self?.playerItems.firstIndex(of: currItem),
               self?.playlist[indexItem] != self?._state.playedUrl {
                
                self?._state.playedUrl = self?.playlist[indexItem]
            }
            
            let duration = CMTimeGetSeconds(currItem.duration)
            self?._state.duration = duration
            
            guard self?.stopObserving == false else { return }
            
            let currentTime = CMTimeGetSeconds(time)
            self?._state.curTime = currentTime
        }
    }
    
    func removeObserver() {
        guard let observer = timeObserver else { return }
        queuePlayer.removeTimeObserver(observer)
    }
    
    deinit {
        removeObserver()
    }
    
}

extension CorePlayerService: AudioPlayerCore {
    func seek(to time: Double) {
        
        stopObserving = true
        
        Task {
            await queuePlayer.seek(to: .init(value: Int64(time), timescale: 1))
            stopObserving = false
        }
    }
    
    var stateUpdate: AnyPublisher<any CorePlayerState, Never> {
        _state.objectWillChange
            .map { [weak self] _ in
                self?._state
            }
            .compactMap({ $0 })
            .eraseToAnyPublisher()
    }
    
    func setupQueue(tracks: [URL]) {
        playlist = tracks
        setupQueue()
    }
    
    func next() {
        nextTrack()
    }
    
    func previus() {
        guard let item = queuePlayer.currentItem else { return }
        guard var index = playerItems.firstIndex(of: item) else { return }
        
        if index == 0 {
            index = max(0, playerItems.count - 1)
        } else {
            index -= 1
        }
        
        let prevItem = playerItems[index]
        
        if queuePlayer.items().contains(prevItem) {
            queuePlayer.remove(prevItem)
        }
        
        guard item != prevItem else { return }
        
        item.seek(to: .zero, completionHandler: nil)
        prevItem.seek(to: .zero, completionHandler: nil)
        
        queuePlayer.insert(prevItem, after: item)
        
        queuePlayer.remove(item)
        queuePlayer.insert(item, after: prevItem)
        
    }
    
    var state: any CorePlayerState {
        _state
    }

}
