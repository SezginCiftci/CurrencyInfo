//
//  MainTableCell.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 14.02.2023.
//

import UIKit

class MainTableCell: UITableViewCell {
    
    var directionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .darkGray
        iv.layer.cornerRadius = 6
        iv.clipsToBounds = true
        return iv
    }()
    
    var currencyTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    
    var currencySubtitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    
    var firstLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textAlignment = .right
        return label
    }()
    
    var secondLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .right
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    private func configureUI() {
        contentView.backgroundColor = UIColor(named: "MainPageBackgroundColor")
        
        contentView.addSubviewsFromExt(directionImageView, currencyTitle, currencySubtitle, firstLabel, secondLabel)
        directionImageView.anchor(top: contentView.topAnchor,
                                  left: contentView.leftAnchor,
                                  bottom: contentView.bottomAnchor,
                                  paddingTop: 10,
                                  paddingLeft: 10,
                                  paddingBottom: 10,
                                  width: 20)
        
        currencyTitle.anchor(top: contentView.topAnchor,
                             left: directionImageView.rightAnchor,
                             paddingTop: 10,
                             paddingLeft: 10,
                             width: 80,
                             height: 20)
        
        currencySubtitle.anchor(top: currencyTitle.bottomAnchor,
                                left: directionImageView.rightAnchor,
                                bottom: contentView.bottomAnchor,
                                paddingTop: 5,
                                paddingLeft: 10,
                                paddingBottom: 5,
                                width: 80)

        firstLabel.anchor(top: contentView.topAnchor,
                               right: contentView.rightAnchor,
                               paddingTop: 10,
                               paddingRight: 30,
                               width: 60,
                               height: 20)
        
        secondLabel.anchor(top: contentView.topAnchor,
                         right: firstLabel.leftAnchor,
                         paddingTop: 10,
                         paddingRight: 30,
                         width: 60,
                         height: 20)
    }
    
    func animateCellClo(_ animateView: UILabel) {
        UIView.transition(with: animateView, duration: 0.1, options: .transitionCrossDissolve) {
            animateView.textColor = .white
        } completion: { _ in
            animateView.textColor = .darkGray
        }
    }
}
