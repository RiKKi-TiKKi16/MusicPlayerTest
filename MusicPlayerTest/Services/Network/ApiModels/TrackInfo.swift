//
//  TrackInfo.swift
//  DarkMap
//
//  Created by Anna Ruslanovna on 23.01.2025.
//

import Foundation

struct TracksResult: Decodable {
    let resultCount: Int
    let results: [TrackInfo]
}

struct TrackInfo: Decodable, Equatable {

    let previewUrl: String?
    let artistName: String
    let trackName: String?
    let trackTimeMillis: Int?
    
    private let artworkUrl30: String?
    private let artworkUrl60: String?
    private let artworkUrl100: String?
    private let artworkUrl600: String?
    
    var previewImageURLString: String? {
        return artworkUrl30 ?? artworkUrl60 ?? artworkUrl100
    }
    
    var imageURLString: String? {
        return artworkUrl600 ?? artworkUrl100 ?? artworkUrl60 ?? artworkUrl30
    }
    
//    let trackId: Int?
//    let collectionPrice: Double?
//    let wrapperType: String?
//    let country: String?
//    let isStreamable: Bool?
//    let releaseDate: String?
//    let artistId: Int?
//    let collectionViewUrl: String?
//    let kind: String??
//    let trackExplicitness: String?
//    let currency: String?
//    let artistViewUrl: String?
//    let trackViewUrl: String?
//    let discCount: Int?
//    let collectionCensoredName: String?
//    let collectionId: Int?
//    let trackCensoredName: String?
//    let trackPrice: Double?
//    let collectionName: String?
//    let trackCount: Int?
//    let discNumber: Int?
//    let collectionExplicitness: String?
//    let trackNumber: Int?
//    let primaryGenreName: String?
}
