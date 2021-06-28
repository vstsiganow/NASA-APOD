//
//  ApiClient.swift
//  NASA-APOD
//
//  Created by vtsyganov on 20.06.2021.
//

import Foundation

enum ApiError: Error {
    case noData
}

protocol ApiClient {
    /* completion определяет ассинхронность функции */
    func getAPOD(completion: @escaping (Result<[APOD], Error>) -> Void)
    func getLastAPOD(completion: @escaping (Result<APOD, Error>) -> Void)
}

class ApiClientImpl: ApiClient {
    func getAPOD(completion: @escaping (Result<[APOD], Error>) -> Void) {
        let session = URLSession.shared
        
        let url = URL(string: "https://api.nasa.gov/planetary/apod?start_date=2021-06-20&end_date=2021-06-25&api_key=DEMO_KEY")!
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: urlRequest, completionHandler: {data, response, error in
            guard let data = data else {
                completion(.failure(ApiError.noData)) // завершаем запрос с ошибкой
                return
            }
            
            do {
                let decoder = JSONDecoder() // определяем тип декодера данных
                
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let response = try decoder.decode([APOD].self, from: data) // пытаемся декодировать полученные данные
                completion(.success(response)) // завершаем запрос с успехом
            } catch(let error) {
                print(error)
                completion(.failure(error))  // завершаем запрос с ошибкой
            }
            
        })
        
        dataTask.resume()
    }
    
    func getLastAPOD(completion: @escaping (Result<APOD, Error>) -> Void) {
        
        let currDate = getCurrencyDate()
        
        let session = URLSession.shared
        
        let url = URL(string: "https://api.nasa.gov/planetary/apod?date=\(currDate)&api_key=DEMO_KEY")!
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: urlRequest, completionHandler: {data, response, error in
            guard let data = data else {
                completion(.failure(ApiError.noData)) // завершаем запрос с ошибкой
                return
            }
            
            do {
                let decoder = JSONDecoder() // определяем тип декодера данных
                
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let response = try decoder.decode(APOD.self, from: data) // пытаемся декодировать полученные данные
                
                completion(.success(response)) // завершаем запрос с успехом
            } catch(let error) {
                print(error)
                completion(.failure(error))  // завершаем запрос с ошибкой
            }
            
        })
        
        dataTask.resume()
    }
}

extension ApiClientImpl {
    
    /*
        Получаем требуемую дату для запроса на API
    */
    private func getCurrencyDate() -> String {
        
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "HH"
        
        let currTime = formatter.string(from: now)
        
        print(currTime)
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        
        /*
            Проверка времени суток, так как файлы на API загружаются не с начала дня
         */
        if Int(currTime) ?? 0 > 9 {
            return formatter.string(from: now)
        } else {
            let lastDate = Calendar.current.date(byAdding: .day, value: -1, to: now)
            
            return formatter.string(from: lastDate ?? now)
        }
    }
    
}
