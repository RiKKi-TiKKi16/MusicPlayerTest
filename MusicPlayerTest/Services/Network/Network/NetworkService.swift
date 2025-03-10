//
//  NetworkService.swift
//  DarkMap
//
//  Created by Anna Ruslanovna on 22.01.2025.
//

import Foundation
import Combine

class NetworkService {
    let core: ConcurencyNetworkCore
    
    init(core: ConcurencyNetworkCore = DefaultNetworkCore()) {
        self.core = core
    }
}
