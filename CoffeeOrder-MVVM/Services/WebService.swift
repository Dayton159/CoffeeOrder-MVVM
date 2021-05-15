//
//  WebService.swift
//  CoffeeOrder-MVVM
//
//  Created by Dayton on 14/05/21.
//

import Foundation


enum NetworkError:Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod:String {
    case get = "GET"
    case post = "POST"
}


struct Resource<T:Codable> {
    let url:URL
    var httpMethod:HttpMethod = .get // Default Value
    var body:Data? = nil // To encode model and send it to server
}

//MARK: - Network Class

class WebService {
    
    // generic to be able to fetch any models provided
    static func load<T>(resource:Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                // if Result is failure then it will return NetworkError
                completion(.failure(.domainError))
                return
            }
            
            do {
                // because it is a generic load func and T is definitely codable
                let result = try JSONDecoder().decode(T.self, from: data)
                
                //using main thread because data will be used to populate UI
                DispatchQueue.main.async {
                    // If result is success it will return Codable T
                    completion(.success(result))
                }
                
            } catch {
                // Result is a frozen enum with only Success and Failure
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
