//
//  APODDetailsViewController.swift
//  NASA-APOD
//
//  Created by vtsyganov on 27.06.2021.
//

import UIKit

class APODDetailsViewController: UIViewController {
    
    var apod = APOD(copyright: "", date: "", explanation: "", imageHDUrl: "", imageUrl: "", title: "")
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var copyrighterLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.addBackground(name: "Space3")
        title = apod.title
        updateDetailsView()
    }
    
    func updateDetailsView() {
        if let hdUrl = apod.imageHDUrl {
            fetchImage(urlString: hdUrl)
        } else {
            fetchImage(urlString: apod.imageUrl)
        }
        
        explanationTextView.text = apod.explanation
        explanationTextView.backgroundColor = .none
        
        dateLabel.text = apod.date
        
        if apod.copyright != nil {
            copyrighterLabel.text = apod.copyright
        } else {
            copyrighterLabel.text = "Unknown Author"
        }
    }
    
    private func fetchImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let response = response {
                print(response)
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.detailsImageView.image = image
                    self.detailsImageView.backgroundColor = .none
                    //self.updateUImageViewSizes(imageView: self.apodImageView, image: image)
                }
            }
        }.resume()
    }
    
}
