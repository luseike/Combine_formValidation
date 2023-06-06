//
//  LoginViewModel.swift
//  FormValidationApp
//
//  Created by 远路蒋 on 2023/6/2.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject{
    enum ViewState {
        case loading
        case success
        case failed
        case none
    }
    
    @Published var email = ""
    @Published var password = ""
    @Published var state: ViewState = .none
    
    var isValidUsernamePublisher: AnyPublisher<Bool, Never>{
        $email.map{ $0.isValidEmail}.eraseToAnyPublisher()
    }
    
    var isValidPasswordPublisher: AnyPublisher<Bool, Never>{
        $password.map{!$0.isEmpty}.eraseToAnyPublisher()
    }
    
    // the combineLatest operator is useful here
        // it gives us a new publisher that receives and combines the latest values form other publishers
    // next we use a map operation to convert our tuple to a single Bool indicating if we can enable the submit button
    
        // Type Erasure(eraseToAnyPublisher)
    // finally i am using the type erasure method eraseToAnyPublisher() to wrap the real type of this publisher so that any subscriber only sees the generic type AnyPublisher<Bool, Never>
    var isSubmitEnabled: AnyPublisher<Bool, Never>{
        Publishers.CombineLatest(isValidUsernamePublisher, isValidPasswordPublisher).map{ $0 && $1 }.eraseToAnyPublisher()
    }
    
    func submitLogin(){
        state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){[weak self] in
            guard let self = self else {return}
            if self.isCorrectLogin(){
                self.state = .success
            }else{
                self.state = .failed
            }
        }
    }
    
    func isCorrectLogin() -> Bool{
        return email == "pgyjyl@163.com" && password == "123456"
    }
}

extension String{
    var isValidEmail: Bool{
        return NSPredicate(
            format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        ).evaluate(with: self)
    }
}
