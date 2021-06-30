//
//  ApiClient.swift
//  NASA-APOD
//
//  Created by vtsyganov on 20.06.2021.
//

import UIKit
import Alamofire

enum ApiError: Error {
    case noData
}

protocol ApiClient {
    /* completion определяет ассинхронность функции */
    func getData(link: String, completion:@escaping (Result<[APOD], AFError>) -> Void)
}

//DEMO_KEY

class ApiClientImpl: ApiClient {
    
    func getData(
        link: String,
        completion: @escaping (Result<[APOD], AFError>) -> Void
    ) {
        guard let url = URL(string: link) else { return }
        
        let decoder = JSONDecoder()
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable (decoder: decoder){ (response: DataResponse<[APOD], AFError>) in
                completion(response.result)
            }
    }
}
