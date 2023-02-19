//
//  WebService.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 14.02.2023.
//

import Foundation

enum NetworkError: String, Error {
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case urlError = "Url is wrong!"
}

struct Resource<T: Codable> {
    let url: URL
}

struct ApiConstants {
    static let listUrl = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterviewSettings"
    static let detailUrl = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterview?fields=las,"
    static let stcs = "&stcs="
}

protocol WebServiceProtocol {
    func loadListData(criteria: (CriteriaValue, CriteriaValue), completion: @escaping (Result<DefaultList, NetworkError>)->())
    func loadDetailData(fields: String, selectedStocks: String, completion: @escaping (Result<ListDetail, NetworkError>)->())
}

struct WebService: WebServiceProtocol {
    func loadListData(criteria: (CriteriaValue, CriteriaValue), completion: @escaping (Result<DefaultList, NetworkError>)->()) {
        guard let url = URL(string: ApiConstants.listUrl) else {
            completion(.failure(.urlError))
            return
        }
        let resource = Resource<DefaultList>(url: url)
        fetchData(resource: resource) { result in
            completion(result)
        }
    }
    
    func loadDetailData(fields: String, selectedStocks: String, completion: @escaping (Result<ListDetail, NetworkError>)->()) {
        guard let url = URL(string: ApiConstants.detailUrl+fields+ApiConstants.stcs+selectedStocks) else {
            completion(.failure(.urlError))
            return
        }
        let resource = Resource<ListDetail>(url: url)
        fetchData(resource: resource) { result in
            completion(result)
        }
    }
}

extension WebService {
    func fetchData<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
            guard let response = response as? HTTPURLResponse  else {
                completion(.failure(.failed))
                return
            }
            guard handleNetworkResponse(response) == nil else {
                completion(.failure(handleNetworkResponse(response)!))
                return
            }
            guard let data = data, error == nil else {
                completion(.failure(.failed))
                return
            }
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                completion(.success(result))
            } else {
                let dummyResult = try? JSONDecoder().decode(T.self, from: DummyJson.jsonData)
                if let dummyResult = dummyResult {
                    completion(.success(dummyResult))
                } else {
                    completion(.failure(.failed))
                }
            }
            
        }.resume()
    }
}

extension WebService {
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkError? {
        switch response.statusCode {
        case 200...299: return nil
        case 401...500: return .authenticationError
        case 501...599: return .badRequest
        case 600: return .outdated
        default: return .failed
        }
    }
}
