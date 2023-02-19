//
//  ViewController.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 14.02.2023.
//

import UIKit

enum CellImageType {
    case Up
    case Down
    case Nothing
    
    var cellImageType: UIImage? {
        switch self {
        case .Up:
            return UIImage(named: "up")
        case .Down:
            return UIImage(named: "down")
        case .Nothing:
            return nil
        }
    }
}

class MainViewController: UIViewController {

    private var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.backgroundColor = UIColor(named: "MainPageBackgroundColor")
        table.register(MainTableCell.self, forCellReuseIdentifier: String(describing: MainTableCell.self))
        table.separatorColor = .darkGray
        table.separatorInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        return table
    }()
    
    private var myDefault = [MypageDefault]()
    private var myPage = [Mypage]()
    private var detailModel = [L]()
    private var cellImageTypes = [CellImageType]()
    private var isChanged = [Bool]()
    
    private var currentCriteriaFirst = CriteriaValue.Son
    private var currentCriteriaSecond = CriteriaValue.FarkYuzde
    
    //MARK: - UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadDefaultData()
    }
    
    //MARK: - Data Loading Methods
    private func loadDefaultData() {
        guard let url = URL(string: "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterviewSettings") else { return }
        
        let resource = Resource<DefaultList>(url: url)
        print("İstek atıldı...")
        WebService().fetchData(resource: resource) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.myDefault = data.mypageDefaults
                    self.myPage = data.mypage
                    self.handleDetailRequest(criteria: self.currentCriteriaFirst, self.currentCriteriaSecond)
                }
            case .failure(let error):
                DispatchQueue.main.async {  [weak self] in
                    guard let self = self else { return }
                    self.showAlertView(title: "Error!", message: error.rawValue, alertActions: [])
                }
            }
        }
    }
    
    private func handleDetailRequest(criteria: CriteriaValue...) {
        let requestCriteria = criteria.map { $0.criteriaValue ?? "" }.joined(separator: ",")
        print("Seçili kriterler: \(requestCriteria)")
        loadDetailData(fields: requestCriteria, selectedStocks: myDefault.map { $0.tke }.joined(separator: "~"))
    }
    
    private func loadDetailData(fields: String, selectedStocks: String) {
        guard let url = URL(string: "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterview?fields=las,\(fields)&stcs=\(selectedStocks)") else {
            self.showAlertView(title: "Error!", message: "Something went wrong...", alertActions: [])
            return
        }
        
        let resource = Resource<ListDetail>(url: url)
        
        WebService().fetchData(resource: resource) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.compareResponseValues(datasL: data.l) {
                        self.detailModel = data.l
                    }
                    
                    self.tableView.reloadData {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.loadDefaultData()
                            print(self.cellImageTypes)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {  [weak self] in
                    guard let self = self else { return }
                    self.showAlertView(title: "Error!", message: error.rawValue, alertActions: [])
                }
            }
        }
    }
    
    //MARK: - Data Compare
    private func compareResponseValues(datasL: [L], completion: () -> ()) {
        cellImageTypes.removeAll()
        isChanged.removeAll()
        if !detailModel.isEmpty {
            for (index, dataL) in datasL.enumerated() {
                let oldData = formatValues(value: dataL.las)
                let newData = formatValues(value: detailModel[index].las)
                    
                if oldData == newData {
                    cellImageTypes.append(.Nothing)
                } else if oldData < newData {
                    cellImageTypes.append(.Up)
                } else {
                    cellImageTypes.append(.Down)
                }
                
                if (dataL.clo ?? "00:00:00" ) == detailModel[index].clo {
                    isChanged.append(false)
                } else {
                    isChanged.append(true)
                }
            }
        }
        completion()
    }
    
    
    private func formatValues(value: String?) -> Float {
           guard let value = value else { return 0.0 }
           
           let formatter = NumberFormatter()
           formatter.numberStyle = .decimal
           formatter.decimalSeparator = ","
           formatter.groupingSeparator = "."
           formatter.allowsFloats = true
           guard let number = formatter.number(from: value)?.floatValue else { return 0.0}
           return number
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
        return myDefault.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainTableCell.self), for: indexPath) as? MainTableCell
        guard let cell = cell else { return UITableViewCell() }
        
        cell.currencyTitle.text = myDefault[indexPath.row].cod
        if !cellImageTypes.isEmpty {
            cell.directionImageView.image = cellImageTypes[indexPath.row].cellImageType
            isChanged[indexPath.row] ? cell.animateCellClo(cell.currencySubtitle) : nil //sadece saat değişince
        }
        if !detailModel.isEmpty {
            cell.currencySubtitle.text = detailModel[indexPath.row].clo
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
            let criteriaStr = detailModel[index].las ?? ""
            return NSAttributedString(string: criteriaStr, attributes: regularAttribute)
        case .FarkYuzde:
            let criteriaStr = detailModel[index].pdd ?? ""
            return NSAttributedString(string: "%\(criteriaStr)", attributes: criteriaStr.contains("-") ? negativeAttribute : positiveAttribute)
        case .Fark:
            let criteriaStr = detailModel[index].ddi ?? ""
            return NSAttributedString(string: criteriaStr, attributes: criteriaStr.contains("-") ? negativeAttribute : positiveAttribute)
        case .Dusuk:
            let criteriaStr = detailModel[index].low ?? ""
            return NSAttributedString(string: criteriaStr, attributes: regularAttribute)
        case .Yuksek:
            let criteriaStr = detailModel[index].hig ?? ""
            return NSAttributedString(string: criteriaStr, attributes: regularAttribute)
        }
    }
}

