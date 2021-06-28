//
//  DataManager.swift
//  NASA-APOD
//
//  Created by vtsyganov on 20.06.2021.
//

import UIKit

class DataManager: ObservableObject {
    
    static let shared = DataManager()
    
    private init() {
        reloadData()
    }
    
    var apods: [APOD] = []
    var apiClient: ApiClient = ApiClientImpl()
    
    func printItems() {
        for apod in apods {
            print(apod)
        }
    }
    
    var getSortedList: [APOD] {
        apods.sorted(by: backward(_:_:))
    }
    
    var getLastAPOD: APOD {
        let sortedList = self.getSortedList
        
        //guard sortedList.count > 0 else { return }
        
        return sortedList[0]
    }
    
    private func backward(_ apod1: APOD, _ apod2: APOD) -> Bool {
        apod1.date > apod2.date
    }
    
}

extension DataManager {
    
    func reloadData() {
        print("Reloading Data")

        DispatchQueue.global().sync {
            
            self.apiClient.getAPOD(completion: { result in
                switch result {
                case .success(let apod):
                    self.apods = apod.reversed()
                    self.printItems()
                case .failure:
                    self.apods = []
                }
            }
            )
        }
    }
}


