//
//  LogoAnimationView.swift
//  NASA-APOD
//
//  Created by vtsyganov on 28.06.2021.
//

import UIKit
import SwiftyGif

class LogoAnimationView: UIView {

    let logoGifImageView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "SpaceCenter.gif") else {
            return UIImageView()
        }
        return UIImageView(gifImage: gifImage, loopCount: 5)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(white: 246.0 / 255.0, alpha: 1)
        addSubview(logoGifImageView)
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoGifImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        logoGifImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

}
