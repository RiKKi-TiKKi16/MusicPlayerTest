//
//  NetworkCore.swift
//  DarkMap
//
//  Created by Anna Ruslanovna on 21.01.2025.
//

import Foundation

protocol ConcurencyNetworkCore {
    func performURL(urlString: String) async throws -> Data
    func performDataRequest(_ request: URLRequest) async throws -> Data
    func performRequest<T: Decodable>(_ request: URLRequest, type: T.Type) async throws -> T
}

class DefaultNetworkCore {
    private let session: URLSession
    private let decoder: JSONDecoder
    let responseQueue: DispatchQueue
    
    init(session: URLSession = .shared,
         decoder: JSONDecoder = .init(),
         responseQueue: DispatchQueue = .main) {
        
        self.session = session
        self.decoder = decoder
        self.responseQueue = responseQueue
    }
    
}

extension DefaultNetworkCore: ConcurencyNetworkCore {
    
    func performURL(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await session.data(from: url)
        return data
    }
    
    func performDataRequest(_ request: URLRequest) async throws -> Data {
        let (data, _) = try await session.data(for: request)
        return data
    }
    
    func performRequest<T: Decodable>(_ request: URLRequest, type: T.Type) async throws -> T {
        let data = try await performDataRequest(request)
        print(String(describing: data.prettyPrintedJSONString))
        let response = try decoder.decode(type, from: data)
        return response
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
