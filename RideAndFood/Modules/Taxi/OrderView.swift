//
//  TaxiOrderView.swift
//  RideAndFood
//
//  Created by Лаура Есаян on 12.11.2020.
//  Copyright © 2020 skillbox. All rights reserved.
//

import UIKit
class OrderView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var firstTextView: CustomTextView!
    @IBOutlet weak var secondTextView: CustomTextView!
    @IBOutlet weak var additionalViewContainer: UIView!
    @IBOutlet weak var button: CustomButton!
    @IBOutlet weak var tapIndicator: UIView!
    @IBOutlet weak var panelView: UIView!
    
    static let ORDER_VIEW = "OrderView"
    
    lazy var tableView: UITableView = {
        UITableView()
    }()
    
    private var savedAddresses: [AddressModel]?
    
    private var currentAddress: String?
    
    var hideTaxiOrderViewAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initWithNib()
    }
    
    // временно включено для тестирования
    convenience init(input: Int) {
        self.init()
        firstTextView.isHidden = false
        secondTextView.isHidden = false
        firstTextView.setTextViewType(.fromAddress)
        secondTextView.setTextViewType(.toAddress)

        firstTextView.customTextViewDelegate = self
        secondTextView.customTextViewDelegate = self
    }
    
    
    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed(OrderView.ORDER_VIEW, owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
        designGeneralViewElements()
        getSavedAddresses()
    }
    
    //MARK: -- private methods
    private func customizeTapIndicator() {
        tapIndicator.layer.cornerRadius = 2
        tapIndicator.backgroundColor = Colors.getColor(.tapIndicatorGray)()
    }
    
    private func customizePanelView() {
        let cornerRadius: CGFloat = 20
        
        panelView.layer.masksToBounds = false
        panelView.layer.cornerRadius = cornerRadius
        panelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        panelView.backgroundColor = Colors.getColor(.buttonWhite)()
        panelView.layer.shadowColor = Colors.getColor(.shadowColor)().cgColor
        panelView.layer.shadowOpacity = 1
        panelView.layer.shadowOffset = CGSize(width: 0, height: -10)
        panelView.layer.shadowRadius = cornerRadius
        panelView.layer.shadowPath = UIBezierPath(rect: panelView.bounds).cgPath
        panelView.layer.shouldRasterize = true
        panelView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func customizeAdditionalViewContainer() {
        additionalViewContainer.layer.borderColor = Colors.getColor(.tableViewBorderGray)().cgColor
        additionalViewContainer.layer.borderWidth = 0.5
    }
    
    private func runAdditionalViewContainerTransitionAnimation(state: Bool) {
        UIView.transition(with: additionalViewContainer, duration: 0.3, options: .curveLinear) { [weak self] in
            guard let self = self else { return }
            self.additionalViewContainer.isHidden = state
        }
    }
    
    private func setGestureRecognizers() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideTaxiOrderView))
        swipeGesture.direction = .down
        self.addGestureRecognizer(swipeGesture)
    }
    
    private func getSavedAddresses() {
        let request = RequestModel<AddressModel>(path: addressPath, method: .get)
        let networker = Networker()
        
        networker.makeRequest(request: request) { [weak self] (results: [AddressModel]?, error: RequestErrorModel?) in
            guard let self = self else { return }
            
            if let results = results {
                self.savedAddresses = results
            }
            
            if let error = error {
                print(error.message)
            }
        }
    }
    
    @objc private func hideTaxiOrderView() {
        hideTaxiOrderViewAction?()
    }
    
    // MARK: -- public methods
    func setTapIndicatorColor(color: UIColor) {
        tapIndicator.backgroundColor = color
    }
    
    func designGeneralViewElements() {
        button.customizeButton(type: .blueButton)
        customizeTapIndicator()
        customizePanelView()
        setGestureRecognizers()
    }
    
    func addTableView() {
        additionalViewContainer.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: additionalViewContainer.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: additionalViewContainer.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: additionalViewContainer.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: additionalViewContainer.bottomAnchor).isActive = true
    }
    
//    func setCurrentAddress(address: String) {
//        self.currentAddress = address
//    }
}

// MARK: - Extensions
extension OrderView: CustomTextViewDelegate {
    func isDestinationAddressSelected(state: Bool) {
        if savedAddresses != nil, savedAddresses!.count != 0 {
            customizeAdditionalViewContainer()
            addTableView()
            runAdditionalViewContainerTransitionAnimation(state: !state)
        }
    }
    
    func mapButtonTapped() {
        print("map Button Tapped")
    }
    
    func locationButtonTapped() {
        print("location Button Tapped")
    }
}

extension OrderView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedAddresses == nil ? 0 : savedAddresses!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AddressesTableView")
        cell.detailTextLabel?.textColor = Colors.getColor(.textGray)()
        cell.imageView?.tintColor = Colors.getColor(.disableGray)()
        cell.imageView?.image = UIImage(named: "Clock")
        
        if let addresses = savedAddresses {
            if let name = addresses[indexPath.row].name, let address = addresses[indexPath.row].address {
                cell.textLabel?.text = name
                cell.detailTextLabel?.text = address
            }

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let addresses = savedAddresses {
            if let address = addresses[indexPath.row].address {
                secondTextView.textField.text = address
                runAdditionalViewContainerTransitionAnimation(state: true)
            }
        }
    }
}