//
//  CriteriaTableCell.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 17.02.2023.
//

import UIKit

class CriteriaTableCell: UITableViewCell {
    
    var criteriaTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    
    var checkedImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.image = UIImage(systemName: "checkmark")
        iv.tintColor = .black
        return iv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        contentView.addSubviewsFromExt(criteriaTitle, checkedImageView)
        criteriaTitle.anchor(top: contentView.topAnchor,
                             left: contentView.leftAnchor,
                             bottom: contentView.bottomAnchor,
                             width: 60)
        
        checkedImageView.anchor(top: contentView.topAnchor,
                                bottom: contentView.bottomAnchor,
                                right: contentView.rightAnchor,
                                width: 20)
    }
    
    func handleCheckmark(with criteria: CriteriaValue) -> Int {
        switch criteria {
        case .Son:
            return 0
        case .FarkYuzde:
            return 1
        case .Fark:
            return 2
        case .Dusuk:
            return 3
        case .Yuksek:
            return 4
        }
    }
    
    func handleCriteria(at index: Int) -> CriteriaValue {
        switch index {
        case 0:
            return .Son
        case 1:
            return .FarkYuzde
        case 2:
            return .Fark
        case 3:
            return .Dusuk
        case 4:
            return .Yuksek
        default:
            return .Son
        }
    }
}

