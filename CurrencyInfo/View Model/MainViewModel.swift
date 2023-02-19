//
//  MainViewModel.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 19.02.2023.
//

import Foundation

enum CellImageType {
    case Up
    case Down
    case Nothing
    
    var cellImageType: String? {
        switch self {
        case .Up:
            return "up"
        case .Down:
            return "down"
        case .Nothing:
            return nil
        }
    }
}

final class MainViewModel {
    
    private let webservice = WebService()
    private var myDefault = [MypageDefault]()
    private var myPage = [Mypage]()
    private var detailModel = [L]()
    private var cellImageTypes = [CellImageType]()
    private var isChanged = [Bool]()
    
    func loadListData(criteria: (CriteriaValue, CriteriaValue), onSuccess: @escaping ()->(), onError: @escaping (_ errorDescription: String)->()) {
        webservice.loadListData(criteria: criteria) { result in
            switch result {
            case .success(let data):
                self.myDefault = data.mypageDefaults
                self.myPage = data.mypage
                self.handleDetailRequest(criteria: criteria.0, criteria.1, onSuccess: onSuccess, onError: onError)
            case .failure(let error):
                onError(error.rawValue)
            }
        }
    }
    
    private func handleDetailRequest(criteria: CriteriaValue..., onSuccess: @escaping ()->(), onError: @escaping (_ errorDescription: String)->()) {
        let requestCriteria = criteria.map { $0.criteriaValue ?? "" }.joined(separator: ",")
        loadDetailData(fields: requestCriteria, selectedStocks: myDefault.map { $0.tke }.joined(separator: "~"), onSuccess: onSuccess, onError: onError)
    }
    
    private func loadDetailData(fields: String, selectedStocks: String, onSuccess: @escaping ()->(), onError: @escaping (_ errorDescription: String)->()) {
        webservice.loadDetailData(fields: fields, selectedStocks: selectedStocks) { result in
            switch result {
            case .success(let data):
                self.compareResponseValues(datasL: data.l) {
                    self.detailModel = data.l
                }
                onSuccess()
            case .failure(let error):
                onError(error.rawValue)
            }
        }
    }
    
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
}

extension MainViewModel {
    
    var defaultListCount: Int {
        return myDefault.count
    }
    
    var cellImagesCount: Int {
        return cellImageTypes.count
    }
    
    var listDetailCount: Int {
        return detailModel.count
    }
    
    func cellForRow(at index: Int) -> MypageDefault {
        return myDefault[index]
    }
    
    func cellImageType(at index: Int) -> String {
        return cellImageTypes[index].cellImageType ?? ""
    }
    
    func isCloChanged(at index: Int) -> Bool {
        return isChanged[index]
    }
    
    func cellForCod(at index: Int) -> String {
        return myDefault[index].cod
    }
    
    func cellForClo(at index: Int) -> String {
        return detailModel[index].clo ?? ""
    }
    
    func cellForLas(at index: Int) -> String {
        return detailModel[index].las ?? ""
    }
    
    func cellForPdd(at index: Int) -> String {
        return detailModel[index].pdd ?? ""
    }
    
    func cellForDdi(at index: Int) -> String {
        return detailModel[index].ddi ?? ""
    }
    
    func cellForLow(at index: Int) -> String {
        return detailModel[index].low ?? ""
    }
    
    func cellForHig(at index: Int) -> String {
        return detailModel[index].hig ?? ""
    }
}
