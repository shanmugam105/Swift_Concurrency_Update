//
//  NetworkService.swift
//  Swift_Concurrency_Update
//
//  Created by Mac on 08/08/22.
//

import Foundation

class NetworkService {
    static func makeRequest<T: Codable>(url: String,
                                 method: HTTPMethod = .GET,
                                 type: T.Type,
                                 completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = url.asURL else {
            completionHandler(.failure(LocalError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil, let data = data else {
                completionHandler(.failure(LocalError.unknownError))
                return
            }
            do {
                let responseData = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(responseData))
            } catch {
                completionHandler(.failure(LocalError.unableToDecode))
            }
        }
        dataTask.resume()
    }
}
