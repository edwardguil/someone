//
//  LoginViewModel.swift
//  someone
//
//  Created by Christina Riabokon on 11/9/21.
//
import Foundation

class LoginViewModel: ObservableObject {
    
    var firstName: String = ""
    @Published var isAuthenticated: Bool = false
    
    func login() {
        
        let defaults = UserDefaults.standard
        
        Webservice().login(firstName: firstName) { result in
            switch result {
                case .success(let token):
                    let emptyMessageArr : [Message] = []
                    let emptyResponseArr : [MessageResponse] = []
                    defaults.setValue(self.firstName, forKey: "firstName")
                    defaults.setValue(emptyMessageArr, forKey: "Messages")
                    defaults.setValue(emptyResponseArr, forKey: "Responses")
                    defaults.setValue(token, forKey: "jsonwebtoken")
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
