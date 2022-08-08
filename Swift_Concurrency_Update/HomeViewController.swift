//
//  HomeViewController.swift
//  Swift_Concurrency_Update
//
//  Created by Mac on 08/08/22.
//

import UIKit

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

class NetworkService: AnyObject {
    func makeRequest<T: Codable>(url: String, completionHandler: (Result<T>) -> Void) {
        
        guard let url = url.asURL else {
            completionHandler(.failure(LocalError.invalidURL))
        }
        
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard error != nil, let data = data {
                completionHandler(.failure(LocalError.unknownError))
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(T, from: data)
                completionHandler(.success(responseData))
            } catch {
                completionHandler(.failure(LocalError.unableToDecode))
            }
        }
        dataTask.resume()
    }
}

extension String {
    var asURL: URL? {
        URL(string: self)
    }
}

enum LocalError: Error {
    case invalidURL
    case unknownError
    case unableToDecode
}
