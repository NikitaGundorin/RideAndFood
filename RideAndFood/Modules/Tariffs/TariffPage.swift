//
//  TariffPage.swift
//  RideAndFood
//
//  Created by Лаура Есаян on 05.11.2020.
//  Copyright © 2020 skillbox. All rights reserved.
//

import UIKit
import Kingfisher

class TariffPage: UIView {
    static let TARIF_PAGE_NIB = "TariffPage"
    
    @IBOutlet var tariffContentView: UIView!
    @IBOutlet weak var coloredIndicatorView: UIView!
    @IBOutlet weak var standartLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var carsLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var aboutTariffLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var iconButtons: [UIButton]!
    @IBOutlet var advantageLabels: [UILabel]!
    @IBOutlet weak var orderButton: CustomButton!
    
    private var tariffModel: TariffModel!
    private var tariffId: Int!
    private var labelCornerRadius: CGFloat = 14
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(tariffModel: TariffModel) {
        self.init()
        self.tariffModel = tariffModel
        if let id = tariffModel.id {
            self.tariffId = id
        }
        
        setColoredIndicatorViewParameters()
        setTariffNameLabelsParameters()
        setAttributedTextToCarsLabel()
        setCarImage()
        setAboutTariffLabelParameters()
        setDescriptionLabelParameters()
        setIconButtonsParameters()
        setAdvantageLabelsParameters()
        setOrderButtonParameters()
    }
    
    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed(TariffPage.TARIF_PAGE_NIB, owner: self, options: nil)
        tariffContentView.frame = bounds
        tariffContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(tariffContentView)
    }
    
    private func setColoredIndicatorViewParameters() {
        switch tariffId {
        case TariffId.premium.rawValue:
            self.coloredIndicatorView.backgroundColor = Colors.getColor(.tariffPurple)()
        case TariffId.business.rawValue:
            self.coloredIndicatorView.backgroundColor = Colors.getColor(.tariffGold)()
        default:
            self.coloredIndicatorView.backgroundColor = Colors.getColor(.tariffGreen)()
        }
    }
    
    private func setTariffNameLabelsParameters() {
        setLabelState(label: &standartLabel, color: Colors.getColor(.disableGray)(), text: TariffStrings.getString(.standart)())
        setLabelState(label: &premiumLabel, color: Colors.getColor(.disableGray)(), text: TariffStrings.getString(.premium)())
        setLabelState(label: &businessLabel, color: Colors.getColor(.disableGray)(), text: TariffStrings.getString(.business)())
        
        switch tariffId {
        case TariffId.premium.rawValue:
            setLabelState(label: &premiumLabel, color: Colors.getColor(.tariffPurple)())
        case TariffId.business.rawValue:
            setLabelState(label: &businessLabel, color: Colors.getColor(.tariffGold)())
        default:
            setLabelState(label: &standartLabel, color: Colors.getColor(.tariffGreen)())
        }
    }
    
    private func setLabelState(label: inout UILabel, color: UIColor, text: String? = nil) {
        label.layer.cornerRadius = labelCornerRadius
        label.backgroundColor = color
        label.textColor = Colors.getColor(.buttonWhite)()
        
        if let text = text {
            label.text = text
        }
    }
    
    private func setAttributedTextToCarsLabel() {
        let cars = NSMutableAttributedString(string: TariffStrings.getString(.cars)(), attributes: [NSAttributedString.Key.foregroundColor : Colors.getColor(.textGray)])
        if let carsString = tariffModel.cars {
            cars.append(NSAttributedString(string: carsString, attributes: [NSAttributedString.Key.foregroundColor : Colors.getColor(.textBlack)()]))
        }
        carsLabel.attributedText = cars
    }
    
    private func setCarImage() {
        if let imageUrlPart = tariffModel.icon {
            let imageUrl = baseUrl + imageUrlPart
            downloadImage(with: baseUrl + imageUrl) { [weak self] (iconImage) in
                guard let self = self else { return }
                guard let iconImage = iconImage else { return }
                self.carImageView.image = iconImage
            }
        }
    }
    
    private func setAboutTariffLabelParameters() {
        aboutTariffLabel.text = TariffStrings.getString(.aboutTariff)()
        aboutTariffLabel.textColor = Colors.getColor(.textBlack)()
    }
    
    private func setDescriptionLabelParameters() {
        if let description = tariffModel.description {
            descriptionLabel.textColor = Colors.getColor(.textGray)()
            descriptionLabel.text = description
        }
    }
    
    private func setIconButtonsParameters() {
        let color: UIColor
        
        switch tariffId {
        case TariffId.premium.rawValue:
            color = Colors.getColor(.tariffPurple)()
        case TariffId.business.rawValue:
            color = Colors.getColor(.tariffGold)()
        default:
            color = Colors.getColor(.tariffGreen)()
        }
        
        for i in 0..<iconButtons.count {
            if let advantage = tariffModel.advantage {
                if let iconUrlPart = advantage[i]?.icon {
                    downloadImage(with: baseUrl + iconUrlPart) { [weak self] (iconImage) in
                        guard let self = self else { return }
                        guard let iconImage = iconImage else { return }
                        self.iconButtons[i].setImage(iconImage, for: .normal)
                    }
                }
            }
            
            iconButtons[i].tintColor = color
        }
    }
    
    private func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
        guard let url = URL.init(string: urlString) else {
            return  imageCompletionHandler(nil)
        }
        
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                imageCompletionHandler(value.image)
            case .failure:
                imageCompletionHandler(nil)
            }
        }
    }
    
    private func setAdvantageLabelsParameters() {
        for i in 0..<advantageLabels.count {
            if let advantage = tariffModel.advantage {
                if let advantageText = advantage[i]?.name {
                    advantageLabels[i].text = advantageText
                }
            }
        }
    }
    
    private func setOrderButtonParameters() {
        orderButton.customizeButton(type: .blueButton)
        orderButton.setTitle(TariffStrings.getString(.orderTaxiButton)(), for: .normal)
    }
}