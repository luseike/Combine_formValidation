//
//  ResultViewController.swift
//  FormValidationApp
//
//  Created by 远路蒋 on 2023/6/2.
//

import UIKit

class ResultViewController: UIViewController {
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Login success"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
