//
//  ItunesRequestBuilder.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 08.03.2025.
//

import Foundation

class DefaultItunesRequestBuilder: BaseRequestBuilder {
    
    private let lock = NSLock()
    
    init() {
        super.init(baseURL: URL(string: "https://itunes.apple.com")!)
    }
}

extension DefaultItunesRequestBuilder: ItunesRequestBuilder {
    func prepareForSearch(text: String) {
        lock.lock()
        reset()
        appendPathComponent("search")
        appendQueryItem("term", value: text)
        lock.unlock()
    }
    
}
