//
//  ViewController.swift
//  NASA-APOD
//
//  Created by vtsyganov on 19.06.2021.
//

import UIKit

protocol UIImageViewDelegate {
    func onImageTapped()
}

class APODViewController: UIViewController {
    
    // MARK: - Properties
    var apod: APOD = APOD(copyright: "", date: "", explanation: "", imageHDUrl: "", imageUrl: "", title: "")
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
        
        //activityIndicatorView.hidesWhenStopped = true
        
        reloadData()
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? APODDetailsViewController else { return }
        
        detailsVC.apod = self.apod
    }
    
    // MARK: - Methods
    func showLoading() {
        activityIndicatorView.isHidden = false
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
        apodImageTitleLabel.text = apod.title
        
        if let hdUrl = apod.imageHDUrl {
            fetchImage(urlString: hdUrl)
        } else {
            fetchImage(urlString: apod.imageUrl)
        }
        
    }
    
    func reloadData() {
        showLoading()
        apiClient.getLastAPOD(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apod):
                    self.apod = apod
                    self.showData()
                    print(self.apod)
                    self.updateApodVC()
                case .failure:
                    self.apod = APOD(copyright: "", date: "", explanation: "", imageHDUrl: "", imageUrl: "", title: "")
                    self.showError()
                }
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
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

