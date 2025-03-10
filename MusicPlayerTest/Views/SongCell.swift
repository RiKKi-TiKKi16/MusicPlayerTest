//
//  SongCell.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 06.03.2025.
//

import SwiftUI
import Kingfisher

struct SongCell: View {
    let track: TrackInfo
    let isPlaying: Bool
    
    var body: some View {
        let titleFont = FontBuilder(customFont: .montserrat, fontSize: 16, lineHeight: 19.5)
        let artistFont = FontBuilder(customFont: .montserrat, fontSize: 13, lineHeight: 15.85)
        
        HStack(alignment: .center, spacing: 0) {
            
            let urlString = track.previewImageURLString ?? track.imageURLString ?? ""
            
            KFImage.url(URL(string: urlString))
                .resizable()
                .cornerRadius(15)
                .frame(width: 64, height: 64)
                .padding(.trailing ,23)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(track.artistName)
                    .font(titleFont.font)
                    .fontWeight(.semibold)
                    .lineSpacing(titleFont.lineSpacing)
                    .padding(.vertical, titleFont.verticalPadding)
                    .lineLimit(1)
                
                Text(track.trackName ?? "")
                    .font(artistFont.font)
                    .fontWeight(.medium)
                    .opacity(0.5)
                    .lineSpacing(artistFont.lineSpacing)
                    .padding(.vertical, artistFont.verticalPadding)
                    .lineLimit(1)
            }
            .foregroundStyle(.white)
            
            Spacer()
            
            let imageName = isPlaying ? "pause.fill" : "play.fill"
            
            Image(systemName: imageName)
                .resizable()
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
        }
    }
}


