//
//  APODCell.swift
//  NASA-APOD
//
//  Created by vtsyganov on 28.06.2021.
//

import UIKit

class APODCell: UICollectionViewCell {
    
    //var apod: APOD?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var apodCellImageView: UIImageView!
    
    func configure(_ apod: APOD) {
        dateLabel.text = "Date: \(apod.date)"
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: apod.getRightURL()) else { return }
            
            DispatchQueue.main.async {
                self.apodCellImageView.image = UIImage(data: imageData)
            }
        }
    }
    
}
