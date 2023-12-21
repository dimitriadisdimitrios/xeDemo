//
//  WebService.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import Foundation

final class WebService {

    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {

        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data, error == nil else {
                completion(.failure(.domainError))
                return
            }

            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }

            DispatchQueue.main.async {
                completion(.success(result))
            }

        }.resume()
    }
}
