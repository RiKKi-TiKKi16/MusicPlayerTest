//
//  ItunesNetworkService.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 08.03.2025.
//

import Foundation

protocol ItunesRequestBuilder: RequestBuilder {
    func prepareForSearch(text: String)
}

class ItunesNetworkService: NetworkService {
    
    let requestBuilder: ItunesRequestBuilder
    
    init(core: ConcurencyNetworkCore = DefaultNetworkCore(),
         requestBuilder: ItunesRequestBuilder) {
        
        self.requestBuilder = requestBuilder
        super.init(core: core)
    }
}

extension ItunesNetworkService: TrackSearchService {
    func search(text: String) async throws -> [TrackInfo] {
        requestBuilder.prepareForSearch(text: text)
        let request = requestBuilder.product()
        return try await core.performRequest(request, type: TracksResult.self).results
    }
}
