//
//  Webservice.swift
//  someone
//
//  Created by Christina Riabokon on 11/9/21.
//
import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

struct MessageRequestBody: Codable {
    let text: String
}

struct MessageResponseBody: Codable {
    let text: String
}

struct LoginRequestBody: Codable {
    let firstName: String

}

struct LoginResponse: Codable {
    let token: String?
}

class Webservice {
        
    func getMessageResponse(token: String, text: String, completion: @escaping (Result<MessageResponseBody, NetworkError>) -> Void) {
        
        
        guard let url = URL(string: "http://127.0.0.1:8000/messaging/message/") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let body = MessageRequestBody(text: text)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        print(request)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            
            guard let messageResponse = try? JSONDecoder().decode(MessageResponseBody.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(messageResponse))
            
            
            
        }.resume()
        
        
    }
    
    
    func login(firstName: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        
        guard let url = URL(string: "http://127.0.0.1:8000/users/") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        let body = LoginRequestBody(firstName: firstName)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No data")))
                return
            }
            
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            guard let token = loginResponse.token else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            completion(.success(token))
            
        }.resume()
        
    }
    
}
