//
//  PlaylistView.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 06.03.2025.
//

import SwiftUI
import Kingfisher

protocol PlaylistViewPresenterProtocol: ObservableObject {
    
    var tracks: [TrackInfo] { get }
    
    func presentBackAction()
    func play()
    func next()
    func prev()
    func seek(to time: Double)
}

struct PlaylistView<Presenter: PlaylistViewPresenterProtocol, MediaInfo: PlayerServiceMediaInfo>: View where MediaInfo.Track == TrackInfo {
    
    @State private var progress: CGFloat = 0
    @State private var carouselIndex = 0
    
    @StateObject var presenter: Presenter
    @StateObject var mediaInfo: MediaInfo
    
    private func formattedDuration(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds - (minutes * 60)
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var duration: Double {
        mediaInfo.duration
    }
    
    var body: some View {
        let timeFont = FontBuilder(customFont: .montserrat, fontSize: 13, lineHeight: 15.85)
        let artistFont = FontBuilder(customFont: .montserrat, fontSize: 13, lineHeight: 15.85)
        let titleFont = FontBuilder(customFont: .montserrat, fontSize: 16, lineHeight: 19.5)
        
        ZStack {
            BackgroundView()
            VStack(alignment: .center, spacing: 0) {
                
                let views = presenter.tracks.map({
                    
                    let kf = KFImage.url(URL(string: $0.imageURLString ?? $0.previewImageURLString ?? ""))
                        .resizable()
                    
                    return AnyView(kf)
                })
                
                CarousalView(carousalLocation: $carouselIndex,
                             views: views)
                
                .padding(.bottom, 34)
                
                VStack(alignment: .center, spacing: 5) {
                    
                    Text(mediaInfo.played?.trackName ?? "")
                        .font(titleFont.font)
                        .fontWeight(.semibold)
                        .lineSpacing(titleFont.lineSpacing)
                        .padding(.vertical, titleFont.verticalPadding)
                        .foregroundColor(.white)
                    Text(mediaInfo.played?.artistName ?? "")
                        .font(artistFont.font)
                        .fontWeight(.medium)
                        .lineSpacing(artistFont.lineSpacing)
                        .padding(.vertical, artistFont.verticalPadding)
                        .foregroundColor(.white)
                        .opacity(0.5)
                }
                .padding(.bottom, 67)
                
                
                VStack(spacing: 11) {
                    
                    let curTime = mediaInfo.curTime
                    
                    CustomSliderView(progress: $progress, change: {
                        let time = duration * $0
                        presenter.seek(to: time)
                    })
                    
                    HStack {
                        
                        Text(formattedDuration(seconds: Int(curTime)))
                            .lineSpacing(timeFont.lineSpacing)
                            .padding(.vertical, timeFont.verticalPadding)
                        Spacer()
                        
                        Text(formattedDuration(seconds: Int(duration)))
                            .lineSpacing(timeFont.lineSpacing)
                            .padding(.vertical, timeFont.verticalPadding)
                    }
                    .font(timeFont.font)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .opacity(0.4)
                }
                .frame(width: 239)
                .padding(.bottom, 48)
                
                HStack {
                    Button(action: {
                        carouselIndex -= 1
                    }) {
                        Image(systemName: "backward.end.fill")
                            .resizable()
                            .foregroundStyle(Color.white)
                            .frame(width: 22, height: 22)
                    }
                    Spacer()
                    Circle()
                        .foregroundStyle(Color.white)
                        .frame(width: 78, height: 78)
                        .overlay {
                            Button(action: {
                                presenter.play()
                            }) {
                                let imageName = mediaInfo.isPlaying ? "pause.fill" : "play.fill"
                                
                                Image(systemName: imageName)
                                    .resizable()
                                    .frame(width: 22, height: 24)
                                    .foregroundStyle(Color.black)
                                    .offset(x: mediaInfo.isPlaying ? 0 : 3)
                            }
                        }
                    Spacer()
                    Button(action: {
                        carouselIndex += 1
                    }) {
                        Image(systemName: "forward.end.fill")
                            .resizable()
                            .foregroundStyle(Color.white)
                            .frame(width: 22, height: 22)
                    }
                }
                .frame(width: 239)
            }
            
            VStack {
                HStack {
                    Button(action: {
                        presenter.presentBackAction()
                    }) {
                        Circle()
                            .foregroundStyle(Color.white)
                            .frame(width: 40, height: 40)
                            .opacity(0.2)
                            .overlay {
                                Image(systemName: "chevron.left")
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.white)
                            }
                    }
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: carouselIndex, { oldValue, newValue in
            if newValue > oldValue {
                presenter.next()
            } else {
                presenter.prev()
            }
        })
        .onAppear(perform: {
            guard mediaInfo.curTime != 0 else { return }
            progress = mediaInfo.curTime / duration
        })
        .onChange(of: mediaInfo.curTime, { oldValue, newValue in
            progress = newValue / duration
            
            if newValue >= duration - 0.5 {
                carouselIndex += 1
            }
        })
    }
    
}

