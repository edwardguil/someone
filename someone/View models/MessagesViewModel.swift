//
//  MessagesViewModel.swift
//  someone
//
//  Created by Christina Riabokon on 11/9/21.
//
import Foundation
import Combine


class MessageViewModel: ObservableObject {
    
    @Published var messages = [Message]()
    
    func getMessageResponse(text:String) {
        self.messages.append(Message(text:text, isUser:true))
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jsonwebtoken") else {
            return
        }
        Webservice().getMessageResponse(token: token, text: text) { (result) in
            switch result {
                case .success(let messageResponseBody):
                    let newMessage = Message(text:messageResponseBody.text, isUser: false)
                    DispatchQueue.main.async {
                        self.messages.append(newMessage)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}


