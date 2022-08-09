//
//  Helper.swift
//  Swift_Concurrency_Update
//
//  Created by Mac on 08/08/22.
//

import Foundation

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
