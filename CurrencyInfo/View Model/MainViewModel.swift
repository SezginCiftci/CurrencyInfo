//
//  MainViewModel.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 19.02.2023.
//

import Foundation
import UIKit

final class MainViewModel {
    
    private var myDefault = [MypageDefault]()
    private var myPage = [Mypage]()
    private var detailModel = [L]()
    private var cellImageTypes = [CellImageType]()
    private var isChanged = [Bool]()
    private var currentCriteriaFirst = CriteriaValue.Son
    private var currentCriteriaSecond = CriteriaValue.FarkYuzde
    
    func loadListData() {
        guard let url = URL(string: "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterviewSettings") else { return }
        
        let resource = Resource<DefaultList>(url: url)
        print("İstek atıldı...")
        WebService().fetchData(resource: resource) { result in
            switch result {
            case .success(let data):
                    self.myDefault = data.mypageDefaults
                    self.myPage = data.mypage
                    self.handleDetailRequest(criteria: self.currentCriteriaFirst, self.currentCriteriaSecond)
            case .failure( _):
                break
            }
        }
    }
    
    var defaultListCount: Int {
        return myDefault.count
    }
    
    func cellForRow(at index: Int) -> MypageDefault {
        return myDefault[index]
    }
    
    func cellImageType(at index: Int) -> UIImage {
        return cellImageTypes[index].cellImageType ?? UIImage()
    }
    
    func isCloChanged(at index: Int) -> Bool {
        return isChanged[index]
    }
    
    func cellForClo(at index: Int) -> String {
        return detailModel[index].clo ?? ""
    }
    
    
    
    private func handleDetailRequest(criteria: CriteriaValue...) {
        let requestCriteria = criteria.map { $0.criteriaValue ?? "" }.joined(separator: ",")
        print("Seçili kriterler: \(requestCriteria)")
        loadDetailData(fields: requestCriteria, selectedStocks: myDefault.map { $0.tke }.joined(separator: "~"))
    }
    
    private func loadDetailData(fields: String, selectedStocks: String) {
        guard let url = URL(string: "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterview?fields=las,\(fields)&stcs=\(selectedStocks)") else {
            //self.showAlertView(title: "Error!", message: "Something went wrong...", alertActions: [])
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
                    //self.showAlertView(title: "Error!", message: error.rawValue, alertActions: [])
                }
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
