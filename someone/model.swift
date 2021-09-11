//
//  model.swift
//  someone
//
//  Created by Christina Riabokon on 10/9/21.
//
/**
import Foundation
import UIKit

extension String: Error {}

class User {
    let email: String
    let password: String
    var firstName: String
    var token: String
    
    init(email: String, password:String, firstName:String, token:String = "") {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.token = token
    }
}

class UserMessages {
    let messages: Array<String>
    
    init(messages: Array<String>) {
        self.messages = messages
    }
}

class APICall {
    
    let url = "127.0.0.1:8000/"
    let user: User
    
    init(user:User) {
        self.user = user
    }
    
    func generateRequest(endPoint: String, type: String) throws -> URLRequest {

    }
    
    func getMessages() throws -> Array<String> {
        guard var request = try? generateRequest(endPoint: "messages", type: "POST") else {throw "Error"}
        let body: [String: AnyHashable] = [
            "token" : user.token,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

        do {
            let response = try JSONDecoder().decode(messagesPostResponse.self, from: data)
            return response.messages
        }
        catch {
            print(error)
        }
        task.resume()
    }
    
    func loginUser() throws -> Void {
        guard let url = URL(string: self.url + "user/") else {
            throw "Error"
        }
        var request  = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "email" : user.email,
            "password" : user.password,
            "firstName" : user.firstName
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

        do {
            let response = try JSONDecoder().decode(userPostResponse.self, from: data)
            self.user.token = response.token
        }
        catch {
            print(error)
        }
        task.resume()
        }
    }
    
    func getUser() {
        
    }
        
}
    
struct userPostResponse: Codable {
    let jsonWebToken: String
}

struct messagesPostResponse: Codable {
    let messages: Array<String>
}
 */
