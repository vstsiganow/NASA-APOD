//
//  ViewController.swift
//  NASA-APOD
//
//  Created by vtsyganov on 19.06.2021.
//

import UIKit

class APODViewController: UIViewController {
    
    // MARK: - Properties
    var apod: APOD?
    
    let apiClient: ApiClient = ApiClientImpl()
    
    // MARK: - IBOutlets
    @IBOutlet var apodView: UIView!
    
    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var apodImageTitleLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apodView.addBackground(name: "Space2")
        
        activityIndicatorView.hidesWhenStopped = true
        
        reloadData()
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? APODDetailsViewController else { return }
        guard let apod = self.apod else { return }
        
        detailsVC.apod = apod
    }
    
    // MARK: - Methods
    func showLoading() {
        activityIndicatorView.startAnimating()
        errorLabel.isHidden = true
        reloadButton.isHidden = true
        
        apodImageView.isHidden = true
        apodImageTitleLabel.isHidden = true
    }
    
    func showData() {
        errorLabel.isHidden = true
        reloadButton.isHidden = true
        
        apodImageView.isHidden = false
        apodImageTitleLabel.isHidden = false
    }
    
    func showError() {
        errorLabel.isHidden = false
        reloadButton.isHidden = false
        
        apodImageView.isHidden = true
        apodImageTitleLabel.isHidden = true
    }
    
    func updateApodVC() {
        guard let apod = self.apod else { return }
        
        apodImageTitleLabel.text = apod.title
        
        if let hdUrl = apod.imageHDUrl {
            fetchImage(urlString: hdUrl)
        } else {
            fetchImage(urlString: apod.imageUrl)
        }
        
    }
    
    func reloadData() {
        showLoading()
        apiClient.getData(
            link: DataManager.shared.link
            , completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let apods):
                        self.apod = DataManager.shared.getSortedList(apods: apods)[0]
                        print(apods)
                        self.showData()
                        self.updateApodVC()
                    case .failure:
                        self.showError()
                    }
                    self.activityIndicatorView.stopAnimating()
                }
            })
    }
    
    func updateUImageViewSizes(imageView: UIImageView, image: UIImage?) {
        let containerView = UIView(frame: CGRect(x:0,y:0,width:320,height:500))
        
        if let image = image {
            let ratio = image.size.width / image.size.height
            print(ratio)
            if containerView.frame.width > containerView.frame.height {
                let newHeight = containerView.frame.width / ratio
                imageView.frame.size = CGSize(width: containerView.frame.width, height: newHeight)
            }
            else{
                let newWidth = containerView.frame.height * ratio
                imageView.frame.size = CGSize(width: newWidth, height: containerView.frame.height)
            }
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: - Private Methods
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
                    self.apodImageView.image = image
                    self.apodImageView.backgroundColor = .none
                    //self.updateUImageViewSizes(imageView: self.apodImageView, image: image)
                }
            }
        }.resume()
    }
}

