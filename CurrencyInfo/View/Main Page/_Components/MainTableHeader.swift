//
//  MainTableHeader.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 14.02.2023.
//

import UIKit

protocol MainTableHeaderDelegate {
    func firstHeaderButtonTapped()
    func secondHeaderButtonTapped()
}

class MainTableHeader: UITableViewHeaderFooterView {
    
    var symbolLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.text = "Sembol"
        return label
    }()
    
    var secondButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.setTitle("%Fark", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageView?.tintColor = .white
        button.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .right
        return button
    }()
    
    var firstButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.setTitle("Son", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageView?.tintColor = .white
        button.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    var delegate: MainTableHeaderDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    private func configureUI()  {
        contentView.addSubviewsFromExt(symbolLabel, secondButton, firstButton)
        
        symbolLabel.anchor(top: contentView.topAnchor,
                           left: contentView.leftAnchor,
                           bottom: contentView.bottomAnchor,
                           paddingTop: 10,
                           paddingLeft: 40,
                           paddingBottom: 10,
                           width: 60)
        
        secondButton.anchor(top: contentView.topAnchor,
                                bottom: contentView.bottomAnchor,
                                right: contentView.rightAnchor,
                                paddingTop: 10,
                                paddingBottom: 10,
                                paddingRight: 20,
                                width: 80)
        
        firstButton.anchor(top: contentView.topAnchor,
                          bottom: contentView.bottomAnchor,
                          right: secondButton.leftAnchor,
                          paddingTop: 10,
                          paddingBottom: 10,
                          paddingRight: 10,
                          width: 80)
        
        secondButton.addTarget(self, action: #selector(secondButtonAct), for: .touchUpInside)
        firstButton.addTarget(self, action: #selector(firstButtonAct), for: .touchUpInside)
    }
    
    @objc func secondButtonAct() {
        delegate?.secondHeaderButtonTapped()
    }
    
    @objc func firstButtonAct() {
        delegate?.firstHeaderButtonTapped()
    }
}

