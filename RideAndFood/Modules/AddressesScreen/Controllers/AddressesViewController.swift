//
//  AddressesViewController.swift
//  RideAndFood
//
//  Created by Oleksandr Karpenko on 09.11.2020.
//  Copyright © 2020 skillbox. All rights reserved.
//

import UIKit
import RxSwift
import Foundation

class AddressesViewController: UIViewController {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorHelper.background.color()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImage(named: "background", in: Bundle.init(path: "Images/Addresses"), with: .none)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.text = AddressesStrings.alertLabel.text()
        label.font = .systemFont(ofSize: 26)
        label.textColor = ColorHelper.secondaryText.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addAddressButton: UIButton = {
        let button = PrimaryButton(title: AddressesStrings.addAddressButton.text())
        button.addTarget(self, action: #selector(showAddAddresController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let padding: CGFloat = 20
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AddressesStrings.title.text()
        navigationItem.backButtonTitle = " "
        navigationController?.navigationBar.tintColor = .gray
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(backgroundView)
        view.addSubview(backgroundImage)
        view.addSubview(alertLabel)
        view.addSubview(addAddressButton)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            alertLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 30),
            
            addAddressButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            addAddressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            addAddressButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
        ])
    }
    
    @objc private func showAddAddresController() {
        let vc = AddAddresViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
