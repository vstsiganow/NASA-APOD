//
//  TabBarController.swift
//  NASA-APOD
//
//  Created by vtsyganov on 20.06.2021.
//

import UIKit
import SwiftyGif

class TabBarController: UITabBarController {
    
    let logoAnimationView = LogoAnimationView()
    
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
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
        //setupViewControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }
    
    
    
    private func setupViewControllers() {
        //guard let viewControllers = viewControllers else { return }
    }
}

extension TabBarController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}
