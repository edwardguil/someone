//
//  MessagesViewModel.swift
//  someone
//
//  Created by Christina Riabokon on 11/9/21.
//
import Foundation

class MessageResponseViewModel: ObservableObject {
    
    func getMessageResponse() {
        var text = ""
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jsonwebtoken") else {
            return
        }
        guard var messageArr = defaults.array(forKey: "Messages") else { return }
        if let messageAny = messageArr.last as? Message {
            text = messageAny.text
        }
        
        Webservice().getMessageResponse(token: token, text: text) { (result) in
            switch result {
                case .success(let messageResponseBody):
                    let messageResponse = MessageResponse(text: messageResponseBody.text)
                    if var messageAny = messageArr.removeLast() as? Message {
                        messageAny.response = messageResponse
                        messageArr.append(messageAny)
                        defaults.setValue(messageArr, forKey: "Messages")
                    }
                    DispatchQueue.main.async {}
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}


