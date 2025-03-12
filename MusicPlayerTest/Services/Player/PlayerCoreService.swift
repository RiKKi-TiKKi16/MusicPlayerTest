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
    @Published private var _state: DefaultState
    
    private var playerAssets = [AVURLAsset]()
    
    init() {
        audioSession = .sharedInstance()
        queuePlayer = .init(items: [])
        _state = DefaultState()
        try? audioSession.setCategory(.playback)
        addStateObserver()
    }
    
    private func setupQueue(playlist: [URL]) {
        
        guard playerAssets.map({ $0.url }) != playlist else { return }
        
        queuePlayer.removeAllItems()
        playerAssets.removeAll()
        
        for url in playlist {
            let asset = AVURLAsset(url: url)
            playerAssets.append(asset)
        }
        
        guard let firstAsset = playerAssets.first else { return }
        
        Task {
            await playAsset(firstAsset)
        }
    }
    
    @discardableResult
    private func prepareAsset(_ asset: AVURLAsset) async -> Double {
        _ = try? await asset.load(.isPlayable)
        guard let cmDuration = try? await asset.load(.duration) else { return 0 }
        return cmDuration.seconds
    }
    
    private func playAsset(_ asset: AVURLAsset) async {
        
        queuePlayer.removeAllItems()
        
        _state.playedUrl = asset.url
        _state.curTime = 0
        
        let duration = await prepareAsset(asset)
        _state.duration = duration
        
        addAssetToQueue(asset)
        play()
        prepareNearbyAssets()
    }
    
    private func addAssetToQueue(_ asset: AVURLAsset) {
        let playerItem = AVPlayerItem(asset: asset)
        queuePlayer.insert(playerItem, after: nil)
    }
    
    private func currentAsset() -> AVURLAsset? {
        guard let playedUrl = _state.playedUrl else { return nil }
        return playerAssets.first(where: { $0.url == playedUrl })
    }
    
    private func nextAsset() -> AVURLAsset? {
        guard let currentAsset = currentAsset() else { return nil }
        guard let currentIndex = playerAssets.firstIndex(of: currentAsset) else { return nil }
        
        var nextIndex: Int = Int(currentIndex) + 1
        
        if nextIndex >= playerAssets.count {
            nextIndex = 0
        }
        
        return playerAssets[nextIndex]
    }
    
    private func prevAsset() -> AVURLAsset? {
        guard let currentAsset = currentAsset() else { return nil }
        guard let currentIndex = playerAssets.firstIndex(of: currentAsset) else { return nil }
        
        var prevIndex = Int(currentIndex) - 1
        
        if prevIndex < 0 {
            prevIndex = playerAssets.count - 1
        }
        
        return playerAssets[prevIndex]
    }
    
    private func prepareNearbyAssets() {
        Task {
            if let nextAsset = self.nextAsset() {
                await prepareAsset(nextAsset)
            } else {
                
            }
        }
        
        Task {
            if let prevAsset = self.prevAsset() {
                await prepareAsset(prevAsset)
            }
        }
    }
    
    func play() {
        queuePlayer.play()
    }
    
    func pause() {
        queuePlayer.pause()
    }
    
    func nextTrack() {
        guard let nextAsset = nextAsset() else { return }
        
        Task {
            await playAsset(nextAsset)
            prepareNearbyAssets()
        }
        
    }
    
    private func addStateObserver() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(trackDidEndPlaying),
                                               name: AVPlayerItem.didPlayToEndTimeNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidChangeRate),
                                               name: AVPlayer.rateDidChangeNotification,
                                               object: nil)
        
        timeObserver = queuePlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1,
                                                                               preferredTimescale: 1),
                                                           queue: .global()) { [weak self] time in
            self?._state.curTime = time.seconds
        }
    }
    
    @objc private func playerDidChangeRate() {
        let isPlaying = queuePlayer.rate == 1
        _state.isPlaying = isPlaying
        try? audioSession.setActive(isPlaying, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
    }
    
    @objc private func trackDidEndPlaying() {
        nextTrack()
    }
    
    private func removeObserver() {
        guard let observer = timeObserver else { return }
        queuePlayer.removeTimeObserver(observer)
        self.timeObserver = nil
    }
    
    deinit {
        removeObserver()
    }
    
}

extension CorePlayerService: AudioPlayerCore {
    func seek(to time: Double) {
        Task {
            await queuePlayer.seek(to: .init(value: Int64(time), timescale: 1))
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
        setupQueue(playlist: tracks)
    }
    
    func next() {
        nextTrack()
    }
    
    func previus() {
        guard let prevAsset = prevAsset() else { return }
        
        Task {
            await playAsset(prevAsset)
        }
    }
    
    var state: any CorePlayerState {
        _state
    }

}
