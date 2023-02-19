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
}

struct Resource<T: Codable> {
    let url: URL
}

struct WebService {
    
    func fetchData<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> ()) {
        
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
            
            guard let response = response as? HTTPURLResponse  else {
                completion(.failure(.failed))
                return
            }
            print(response.statusCode)
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
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkError? {
        switch response.statusCode {
        case 200...299: return nil
        case 401...500: return  .authenticationError
        case 501...599: return .badRequest
        case 600: return .outdated
        default: return .failed
        }
    }
}

class DummyJson {
    static let jsonData = """
{
  "l": [
    {
        "tke": "XU100.I.BIST",
        "clo": "18:10:12",
        "ddi": "18,26",
        "las": "5.026,83",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "XU050.I.BIST",
        "clo": "18:10:12",
        "ddi": "20,17",
        "las": "4.533,37",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "XU030.I.BIST",
        "clo": "18:10:10",
        "ddi": "24,70",
        "las": "5.635,18",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "USD/TRL",
        "ddi": "0,0148",
        "las": "18,8621",
        "clo": "23:59:44",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "EUR/TRL",
        "ddi": "0,0248",
        "las": "20,1738",
        "clo": "23:59:56",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "EUR/USD",
        "ddi": "0,00209",
        "las": "1,06944",
        "clo": "23:59:58",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "XAU/USD",
        "ddi": "5,88",
        "las": "1.841,86",
        "clo": "23:59:57",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "XGLD",
        "clo": "23:59:57",
        "ddi": "3,992",
        "las": "1.117,060",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "BRENT",
        "ddi": "-1,99",
        "las": "83,15",
        "clo": "01:59:00",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    }
  ],
  "z": "0"
}
""".data(using: .utf8)!
}



