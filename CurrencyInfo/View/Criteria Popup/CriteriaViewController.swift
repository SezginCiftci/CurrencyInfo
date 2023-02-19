//
//  CriteriaViewController.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 14.02.2023.
//

import UIKit

enum CriteriaValue: String, CaseIterable {
    case Son = "Son"
    case FarkYuzde = "%Fark"
    case Fark = "Fark"
    case Dusuk = "Düşük"
    case Yuksek = "Yüksek"
    
    var criteriaValue: String? {
        switch self {
        case .Son:
            return "las"
        case .FarkYuzde:
            return "pdd"
        case .Fark:
            return "ddi"
        case .Dusuk:
            return "low"
        case .Yuksek:
            return "hig"
        }
    }
}

enum OpenedCriteriaWith: CGFloat {
    case FirstButton = 70.0
    case SecondButton = 10.0
}

protocol CriteriaViewControllerDelegate {
    func didSelectCriteria(criteria: CriteriaValue, openedWith: OpenedCriteriaWith)
}

class CriteriaViewController: UIViewController {
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.backgroundColor = .white
        table.register(CriteriaTableCell.self, forCellReuseIdentifier: String(describing: CriteriaTableCell.self))
        table.separatorStyle = .none
        table.isScrollEnabled = false
        return table
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var criteriaSelect: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .darkGray
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.text = "Kriter Seçiniz"
        return label
    }()

    var delegate: CriteriaViewControllerDelegate?
    private var openedCriteriaWith: OpenedCriteriaWith
    private var criteriaValue: CriteriaValue
    
    //MARK: - Custom Initializers
    init(_ openCriteriaWith: OpenedCriteriaWith, _ criteriaValue: CriteriaValue) {
        self.openedCriteriaWith = openCriteriaWith
        self.criteriaValue = criteriaValue
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(.FirstButton, .Son)
    }
    
    //MARK: - UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - UI Configurations
    private func configureUI() {
        view.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubviewsFromExt(containerView)
        containerView.anchor(top: view.topAnchor,
                             right: view.rightAnchor,
                             paddingTop: 220,
                             paddingRight: openedCriteriaWith.rawValue,
                             width: 150,
                             height: 300)
        
        
        containerView.addSubviewsFromExt(tableView, criteriaSelect)
        criteriaSelect.anchor(top: containerView.topAnchor,
                              left: containerView.leftAnchor,
                              right: containerView.rightAnchor,
                              paddingTop: 10,
                              paddingLeft: 10,
                              paddingRight: 10,
                              height: 30)
       
        tableView.anchor(top: criteriaSelect.bottomAnchor,
                         left: containerView.leftAnchor,
                         bottom: containerView.bottomAnchor,
                         right: containerView.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 20,
                         paddingBottom: 20,
                         paddingRight: 20)
        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
//        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
}

//MARK: - UITableView Delegate Methods
extension CriteriaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CriteriaValue.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CriteriaTableCell.self), for: indexPath) as? CriteriaTableCell
        guard let cell = cell else { return UITableViewCell() }
        cell.criteriaTitle.text = CriteriaValue.allCases[indexPath.row].rawValue
        cell.checkedImageView.isHidden = indexPath.row == cell.handleCheckmark(with: criteriaValue) ? false : true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CriteriaTableCell {
            delegate?.didSelectCriteria(criteria: cell.handleCriteria(at: indexPath.row), openedWith: openedCriteriaWith)
            dismissView()
        }
    }
}

