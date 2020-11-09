//
//  AddressView.swift
//  RideAndFood
//
//  Created by Oleksandr Karpenko on 09.11.2020.
//  Copyright © 2020 skillbox. All rights reserved.
//

import UIKit
import Foundation

class AddressView: UIView {
    
    private lazy var addressTextField: UITextField = {
        let textField = MaskTextField(format: "[00]", valueChangedCallback: nil)
        textField.placeholder = AddAddressesStrings.addresName.text()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    private let padding: CGFloat = 20
    
    func setupLayout() {
        backgroundColor = ColorHelper.background.color()
        
        addSubview(addressTextField)
        
        NSLayoutConstraint.activate([
            addressTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            addressTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            addressTextField.topAnchor.constraint(equalTo: topAnchor, constant: 100)
        ])
    }
}
