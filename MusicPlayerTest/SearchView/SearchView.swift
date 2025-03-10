//
//  SearchView.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 06.03.2025.
//

import SwiftUI

protocol SearchViewPresenterProtocol: ObservableObject {
    var searchString: String { get set }
    var tracks: [TrackInfo] { get }
    func playTrack(_ track: TrackInfo)
}


struct SearchView<Presenter: SearchViewPresenterProtocol, MediaInfo: PlayerServiceMediaInfo>: View where MediaInfo.Track == TrackInfo {
    
    @StateObject var presenter: Presenter
    @StateObject var mediaInfo: MediaInfo
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                SearchButton(searchText: $presenter.searchString)
                    .padding(.bottom, 20)
                
                List(presenter.tracks.indices, id: \.self) { index in
                    
                    let track = presenter.tracks[index]
                    let isPlaying = mediaInfo.played == track && mediaInfo.isPlaying
                    
                    Button {
                        presenter.playTrack(track)
                    } label: {
                        SongCell(track: track, isPlaying: isPlaying)
                    }
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                }
                .padding(.horizontal, 24)
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            }
        }
    }
}
