//
//  RequestBuilder.swift
//  DarkMap
//
//  Created by Anna Ruslanovna on 22.01.2025.
//

import Foundation

protocol RequestBuilder {
    func reset()
    func product() -> URLRequest
}

class BaseRequestBuilder: RequestBuilder {
    enum HTTPMethod: String {
        case get
        case post
        case put
        case delete
        case patch
    }
    private var urlComponents: URLComponents
    private var headers: [String: String] = [:]
    private var httpMethod: HTTPMethod = .get
    private var body: Encodable?
    
    init(baseURL: URL) {
        self.urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
    }
    
    convenience init(urlString: String) throws {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        self.init(baseURL: url)
    }
    
    @discardableResult
    func appendPathComponent(_ pathComponent: String) -> Self {
        
        if !pathComponent.hasPrefix("/") {
            urlComponents.path += "/"
        }
        
        urlComponents.path += pathComponent
        return self
    }
    
    @discardableResult
    func appendQueryItem(_ name: String, value: String?) -> Self {
        
        if urlComponents.queryItems == nil {
            urlComponents.queryItems = []
        }
        
        if let value = value, !value.isEmpty {
            urlComponents.queryItems?.append(URLQueryItem(name: name, value: value))
        }
        
        return self
    }
    
    @discardableResult
    func setHeaders(_ headers: [String: String]) -> Self {
        self.headers = headers
        return self
    }
    
    @discardableResult
    func appendHeader(_ key: String, _ value: String) -> Self {
        headers[key] = value
        return self
    }
    
    func setMethod(_ method: HTTPMethod) -> Self {
        self.httpMethod = method
        return self
    }
    
    func setBody<T: Encodable>(_ body: T) -> Self {
        self.body = body
        appendHeader("Content-Type", "application/json")
        return self
    }
    
    func product() -> URLRequest {
        var request = URLRequest(url: urlComponents.url!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod.rawValue
        
        if let body, let jsonData = try? JSONEncoder().encode(body) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func reset() {
        headers = [:]
        urlComponents.path = ""
        urlComponents.queryItems = []
        httpMethod = .get
        body = nil
    }
}
