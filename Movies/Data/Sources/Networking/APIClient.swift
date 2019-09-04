//
//  APIClient.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import Alamofire

final class APIClient {
    private let reachability: ReachabilityManager
    private let manager: SessionManager
    private let baseUrl: URL
    
    required init(baseUrl: URL, manager: SessionManager, reachability: ReachabilityManager) {
        self.baseUrl = baseUrl
        self.manager = manager
        self.reachability = reachability
    }
    
    @discardableResult
    func execute(_ request: RequestConvertible, completion: @escaping (Swift.Result<Data, APIClientError>) -> Void) -> DataRequest? {
        guard reachability.isReachable else {
            completion(.failure(.noInternetConnection)) ; return nil
        }
        guard let r = try? request.asURLRequest(baseUrl: baseUrl) else {
            completion(.failure(.other)) ; return nil
        }
        let request = manager.request(r).validate(statusCode: 200..<500).validate().responseJSON(queue: .networking) { (response) in
            guard let data = response.data else {
                completion(.failure(.other)) ; return
            }
            
            completion(.success(data))
        }
        
        return request
    }
}
