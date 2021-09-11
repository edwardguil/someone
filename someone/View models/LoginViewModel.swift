//
//  LoginViewModel.swift
//  someone
//
//  Created by Christina Riabokon on 11/9/21.
//
import Foundation

class LoginViewModel: ObservableObject {

    @Published var isAuthenticated: Bool = false
    
    func login(firstName:String) {
        
        let defaults = UserDefaults.standard
        
        Webservice().login(firstName: firstName) { result in
            switch result {
                case .success(let token):
                    defaults.setValue(true, forKey: "hasLaunched")
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
