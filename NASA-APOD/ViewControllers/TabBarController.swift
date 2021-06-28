//
//  TabBarController.swift
//  NASA-APOD
//
//  Created by vtsyganov on 20.06.2021.
//

import UIKit

class TabBarController: UITabBarController {
    
//    var apods: [APOD] = []
//
//    let mainQueue = DispatchQueue.main
//    let globalDefault = DispatchQueue.global()
//    let inactiveQueue = DispatchQueue(
//        label: "ru.vtsyganov.inactiveQueue",
//        attributes: [.concurrent, .initiallyInactive])
//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let apodVC = viewControllers?.first as! APODViewController
        //let contactListVC = viewControllers?.last as! ContactListViewController
        apodVC.navigationItem.title = "1"
    }
//        inactiveQueue.async {
//
//
//
//            if self.apods.count > 0  {
//                apodVC.apod = self.apods[0]
//            } else {
//                let now = Date()
//
//                let formatter = DateFormatter()
//                formatter.dateStyle = .short
//                formatter.timeStyle = .none
//                formatter.dateFormat = "yyyy-MM-dd"
//
//                let currDate = formatter.string(from: now)
//
//                apodVC.apod = APOD(copyright: "", date: currDate, explanation: "", imageHDUrl: "", imageUrl: "", title: "")
//            }
//            print(self.apods.count)
//            //apodVC.apodView.reloadInputViews()
//        }
//
//        inactiveQueue.activate()
//
//    }
    
    
}
