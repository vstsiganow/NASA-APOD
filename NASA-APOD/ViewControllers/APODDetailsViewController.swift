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
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var copyrighterLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addBackground(name: "Space3")
        title = apod.title
        updateDetailsView()
    }
    
    func updateDetailsView() {
        if let hdUrl = apod.imageHDUrl {
            fetchImage(urlString: hdUrl)
        } else {
            fetchImage(urlString: apod.imageUrl)
        }
        
        explanationLabel.text = apod.explanation
        dateLabel.text = apod.date
        
        if apod.copyright != nil {
            copyrighterLabel.text = apod.copyright
        } else {
            copyrighterLabel.text = "Unknown"
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
