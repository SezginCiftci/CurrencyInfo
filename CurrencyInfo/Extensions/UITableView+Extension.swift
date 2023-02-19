//
//  UITableView+Extension.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 18.02.2023.
//

import UIKit

extension UITableView {
    func reloadData(completion: @escaping() -> ()) {
        UIView.animate(withDuration: 0) {
            self.reloadData()
        } completion: { _ in
            completion()
        }
    }
}
