//
//  LoginViewModel.swift
//  someone
//
//  Created by Christina Riabokon on 11/9/21.
//
import Foundation

class LoginViewModel: ObservableObject {

    @Published var isAuthenticated: Bool = false
    
    func login(firstName:String, text:String, viewModel:MessageViewModel) {
        
        let defaults = UserDefaults.standard
        
        Webservice().login(firstName: firstName) { result in
            switch result {
                case .success(let token):
                    defaults.setValue(token, forKey: "jsonwebtoken")
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        viewModel.getMessageResponse(text: text, addMessage: false)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
