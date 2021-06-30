//
//  DataManager.swift
//  NASA-APOD
//
//  Created by vtsyganov on 20.06.2021.
//

import UIKit

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    // MARK: - Private Properties
    private let apiKey = "q4LCjd8gyrs4PGLrycYHC87Kl9XQ0dv7TFj6UZkQ"
    
    private init() {
    }
    
    // MARK: - Properties
    var apods: [APOD] = []
    
    var apiClient: ApiClient = ApiClientImpl()
    
    var datePeriod: [String] {
        getMonthIntervalDates(days: 30)
    }
    
    var currentlyDate: String {
        getCurrencyDate()
    }
    
    var link: String {
        let period = self.datePeriod
        let key = self.apiKey
        return "https://api.nasa.gov/planetary/apod?start_date=\(period[0])&end_date=\(period[1])&api_key=\(key)"
    }
    
    //MARK: - Methods
    func printItems(items: [Any]) {
        for item in items {
            print(item)
        }
    }
    
    func getSortedList(apods: [APOD]) -> [APOD] {
        apods.sorted(by: backward(_:_:))
    }
    
//    func getLastAPOD(apods: [APOD]) -> APOD {
//        let sortedList = self.getSortedList(apods: apods)
//        return sortedList[0]
//    }
    
    //MARK: - Private Methods
    
    private func backward(_ apod1: APOD, _ apod2: APOD) -> Bool {
        apod1.date > apod2.date
    }
    
    /*
     Получаем требуемую дату для запроса на API
     */
    private func getCurrencyDate() -> String {
        let now = Date()
        
        let hourFormatter = DateFormatter.articleOnlyHourFormatter
        let dateFormatter = DateFormatter.articleDateFormatter
        
        let currTime = hourFormatter.string(from: now)

        /*
         Проверка времени суток, так как файлы на API загружаются не с начала дня
         */
        if Int(currTime) ?? 0 > 9 {
            return dateFormatter.string(from: now)
        } else {
            let lastDate = Calendar.current.date(byAdding: .day, value: -1, to: now)
            
            return dateFormatter.string(from: lastDate ?? now)
        }
    }
    
    private func getMonthIntervalDates(days: Int) -> [String] {
        let now = Date()
        
        let hourFormatter = DateFormatter.articleOnlyHourFormatter
        let dateFormatter = DateFormatter.articleDateFormatter
        
        let currTime = hourFormatter.string(from: now)
        
        /*
         Проверка времени суток, так как файлы на API загружаются не с начала дня
         */
        if Int(currTime) ?? 0 > 9 {
            let startDate = Calendar.current.date(byAdding: .day, value: -days, to: now) ?? now
            
            return[dateFormatter.string(from: startDate) , dateFormatter.string(from: now)]
        } else {
            let startDate = Calendar.current.date(byAdding: .day, value: -31, to: now)
            let endDate = Calendar.current.date(byAdding: .day, value: -1, to: now)
            
            return [dateFormatter.string(from: startDate ?? now), dateFormatter.string(from: endDate ?? now)]
        }
    }
    
}

//MARK: - Extensions
//extension DataManager {
//
//    func reloadData(completion: (Result<[APOD], Error>) -> Void) {
//        print("Reloading Data")
//
//        apiClient.getAlamoResponse(completion: { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let apods):
//                    print("Start Alamofire request")
//                    self.apods = self.getSortedList(apods: apods)
//                    //self.printItems()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    self.apods = []
//                }
//                print("Data Manager count: \(self.apods.count)")
//            }
//        })
//    }
//}


