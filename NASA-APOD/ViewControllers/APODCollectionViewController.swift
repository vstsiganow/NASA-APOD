//
//  APODCollectionViewController.swift
//  NASA-APOD
//
//  Created by vtsyganov on 28.06.2021.
//

import UIKit


class APODCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    private var apods: [APOD] = []
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
        left: 20.0,
        bottom: 20.0,
        right: 20.0)
    
    
    let apiClient: ApiClient = ApiClientImpl()
    
    private let reuseIdentifier = "ApodCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        //collectionView.addBackground(name: "Space4")
        
    }
    
    
     // MARK: - Navigation
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier {
            let newViewController = segue.destination as! APODDetailsViewController
            let indexPath = sender as! NSIndexPath
            let apod = apods[indexPath.row]
            newViewController.apod = apod
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailsFromCollection", sender: self)
    }

    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return apods.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! APODCell
        
        if !apods.isEmpty {
            cell.configure(apods[indexPath.row])
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension APODCollectionViewController {
    func reloadData() {
        //showLoading()
        apiClient.getAPOD(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apods):
                    self.apods = apods
                    //self.showData()
                    print(self.apods)
                case .failure:
                    self.apods = []
                //self.showError()
                }
                print("Reload collection")
                print(self.apods.count)
                self.collectionView.reloadData()
                //self.activityIndicatorView.stopAnimating()
            }
        })
    }
    
}

// MARK: - CollectionLayout
extension APODCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
}
