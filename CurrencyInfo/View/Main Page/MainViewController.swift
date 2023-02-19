//
//  ViewController.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 14.02.2023.
//

import UIKit

class MainViewController: UIViewController {

    private var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.backgroundColor = UIColor(named: "MainPageBackgroundColor")
        table.register(MainTableCell.self, forCellReuseIdentifier: String(describing: MainTableCell.self))
        table.separatorColor = .darkGray
        table.separatorInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        return table
    }()
    
    private var currentCriteriaFirst: CriteriaValue = .Son
    private var currentCriteriaSecond: CriteriaValue = .FarkYuzde
    private var viewModel = MainViewModel()
    
    //MARK: - UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
    }
    
    //MARK: - Data Loading
    private func loadData() {
        viewModel.loadListData(criteria: (currentCriteriaFirst, currentCriteriaSecond)) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.loadData()
                    }
                }
            }
        } onError: { errorDescription in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showAlertView(title: "Error!", message: errorDescription, alertActions: [])
            }
        }
    }
    
    //MARK: - UI Configurations
    private func configureUI() {
        view.backgroundColor = UIColor(named: "MainPageBackgroundColor")
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Currency Info"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubviewsFromExt(tableView)
        tableView.anchor(top: view.layoutMarginsGuide.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor)
    }

}

//MARK: - CriteriaViewController Delegate Methods
extension MainViewController: CriteriaViewControllerDelegate {
    func didSelectCriteria(criteria: CriteriaValue, openedWith: OpenedCriteriaWith) {
        switch openedWith {
        case .FirstButton:
            currentCriteriaFirst = criteria
        case .SecondButton:
            currentCriteriaSecond = criteria
        }
    }
}

//MARK: - MainTableHeader Delegate Methods
extension MainViewController: MainTableHeaderDelegate {
    func firstHeaderButtonTapped() {
        let criteriaVC = CriteriaViewController(.FirstButton, currentCriteriaFirst)
        criteriaVC.delegate = self
        criteriaVC.modalTransitionStyle = .crossDissolve
        criteriaVC.modalPresentationStyle = .overCurrentContext
        present(criteriaVC, animated: true)
    }
    
    func secondHeaderButtonTapped() {
        let criteriaVC = CriteriaViewController(.SecondButton, currentCriteriaSecond)
        criteriaVC.delegate = self
        criteriaVC.modalTransitionStyle = .crossDissolve
        criteriaVC.modalPresentationStyle = .overCurrentContext
        present(criteriaVC, animated: true)
    }
}

//MARK: - UITableView Delegate Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MainTableHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        headerView.delegate = self
        headerView.firstButton.setTitle(currentCriteriaFirst.rawValue, for: .normal)
        headerView.secondButton.setTitle(currentCriteriaSecond.rawValue, for: .normal)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.defaultListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainTableCell.self), for: indexPath) as? MainTableCell
        guard let cell = cell else { return UITableViewCell() }
        
        cell.currencyTitle.text = viewModel.cellForCod(at: indexPath.row)
        if viewModel.cellImagesCount > 0 {
            cell.directionImageView.image = UIImage(named: viewModel.cellImageType(at: indexPath.row))
            viewModel.isCloChanged(at: indexPath.row) ? cell.animateCellClo(cell.currencySubtitle) : nil
        }
        
        if viewModel.listDetailCount > 0 {
            cell.currencySubtitle.text = viewModel.cellForClo(at: indexPath.row)
            cell.secondLabel.attributedText = returnCriteriaType(at: indexPath.row, with: currentCriteriaFirst)
            cell.firstLabel.attributedText = returnCriteriaType(at: indexPath.row, with: currentCriteriaSecond)
        }
        
        return cell
    }
        
    private func returnCriteriaType(at index: Int, with criteria: CriteriaValue) -> NSAttributedString {
        let positiveAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGreen
        ]
        let negativeAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemRed
        ]
        let regularAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        switch criteria {
        case .Son:
            return NSAttributedString(string: viewModel.cellForLas(at: index), attributes: regularAttribute)
        case .FarkYuzde:
            return NSAttributedString(string: "%\(viewModel.cellForPdd(at: index))", attributes: viewModel.cellForLas(at: index).contains("-") ? negativeAttribute : positiveAttribute)
        case .Fark:
            return NSAttributedString(string: "\(viewModel.cellForDdi(at: index))", attributes: viewModel.cellForDdi(at: index).contains("-") ? negativeAttribute : positiveAttribute)
        case .Dusuk:
            return NSAttributedString(string: viewModel.cellForLow(at: index), attributes: regularAttribute)
        case .Yuksek:
            return NSAttributedString(string: viewModel.cellForHig(at: index), attributes: regularAttribute)
        }
    }
}

