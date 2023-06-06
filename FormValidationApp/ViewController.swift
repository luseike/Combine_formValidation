//
//  ViewController.swift
//  FormValidationApp
//
//  Created by 远路蒋 on 2023/6/2.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var viewModel = LoginViewModel()
    var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPublishers()
    }
    
    func setupPublishers(){
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
            .map{($0.object as! UITextField).text ?? ""}
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .map{($0.object as! UITextField).text ?? ""}
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isSubmitEnabled
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &cancellables)
        
        viewModel.$state.sink{[weak self] state in
            switch state{
            case .loading:
                self?.submitButton.isEnabled = false
                self?.submitButton.setTitle("Loading..", for: .normal)
                self?.hideError(true)
            case .success:
                self?.showResultScreen()
                self?.resetButton()
                self?.hideError(true)
            case .failed:
                self?.resetButton()
                self?.hideError(false)
            case .none:
                break
            }
        }.store(in: &cancellables)
    }

    
    @IBAction func onSubmit(_ sender: Any) {
        viewModel.submitLogin()
    }
    func resetButton(){
        submitButton.setTitle("Login", for: .normal)
        submitButton.isEnabled = true
    }
    
    func showResultScreen(){
        let resultVc = ResultViewController()
        navigationController?.pushViewController(resultVc, animated: true)
    }
    
    func hideError(_ isHidden: Bool){
        errorLabel.alpha = isHidden ? 0 : 1
    }

}

