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

private let apiKey = "q4LCjd8gyrs4PGLrycYHC87Kl9XQ0dv7TFj6UZkQ"
//DEMO_KEY

class ApiClientImpl: ApiClient {
    func getAPOD(completion: @escaping (Result<[APOD], Error>) -> Void) {
        
        let period = getMonthIntervalDates(days: 31)
        
        let session = URLSession.shared
        
        let urlStr = "https://api.nasa.gov/planetary/apod?start_date=\(period[0])&end_date=\(period[1])&api_key=\(apiKey)"
        
        let url = URL(string: urlStr)!
        
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

        let urlStr = "https://api.nasa.gov/planetary/apod?date=\(currDate)&api_key=\(apiKey)"
        
        let url = URL(string: urlStr)!
        
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
    
    private func getMonthIntervalDates(days: Int) -> [String] {
        
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "HH"
        
        let currTime = formatter.string(from: now)

        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        
        /*
            Проверка времени суток, так как файлы на API загружаются не с начала дня
         */
        if Int(currTime) ?? 0 > 9 {
            let startDate = Calendar.current.date(byAdding: .day, value: -days, to: now) ?? now
            
            return[formatter.string(from: startDate) , formatter.string(from: now)]
        } else {
            let startDate = Calendar.current.date(byAdding: .day, value: -31, to: now)
            let endDate = Calendar.current.date(byAdding: .day, value: -1, to: now)
            
            return [formatter.string(from: startDate ?? now), formatter.string(from: endDate ?? now)]
        }
    }
    
}
