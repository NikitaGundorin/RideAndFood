//
//  AddAddresViewController.swift
//  RideAndFood
//
//  Created by Oleksandr Karpenko on 09.11.2020.
//  Copyright © 2020 skillbox. All rights reserved.
//

import UIKit
import Foundation

class AddAddresViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 420)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorHelper.background.color()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addressView: UIView = {
        let view = AddressView()
        view.showMapButtonCallback = {
            
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deliveryAddressTitleView: UIView = {
        let view = DeliveryAddressTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deliveryAddressView: UIView = {
        let view = DeliveryAddressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addressView, deliveryAddressTitleView, deliveryAddressView])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = PrimaryButton(title: AddAddressesStrings.saveButton.text())
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AddAddressesStrings.title.text()
        setupLayout()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private let padding: CGFloat = 20
    
    private lazy var scrollViewBottonConstraint = scrollView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
    func setupLayout() {
        scrollView.addSubview(backgroundView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(saveButton)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollViewBottonConstraint,
            
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -padding),
            
            addressView.heightAnchor.constraint(equalToConstant: 130),
            deliveryAddressTitleView.heightAnchor.constraint(equalToConstant: 45),
            deliveryAddressView.heightAnchor.constraint(equalToConstant: 130),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
        ])
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           keyboardSize.height > 0 {
            
            scrollViewBottonConstraint.constant = -keyboardSize.height - view.safeAreaInsets.bottom
            
            UIView.animate(withDuration: ConstantsHelper.baseAnimationDuration.value()) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollViewBottonConstraint.constant = -padding
        
        UIView.animate(withDuration: ConstantsHelper.baseAnimationDuration.value()) {
            self.view.layoutIfNeeded()
        }
    }
}
