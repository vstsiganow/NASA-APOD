//
//  APODCollectionViewController.swift
//  NASA-APOD
//
//  Created by vtsyganov on 28.06.2021.
//

import UIKit


class APODCollectionViewController: UICollectionViewController {
    
    // MARK: - Private Properties
    private var apods: [APOD] = []
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
        left: 20.0,
        bottom: 20.0,
        right: 20.0)
    private let cellIdentifier = "ApodCell"
    private let detailViewIdentifier = "showDetailsFromCollection"
    
    // MARK: - Properties
    let apiClient: ApiClient = ApiClientImpl()
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        loadData()
        //collectionView.addBackground(name: "Space4")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailViewIdentifier {
            if let indexPaths = collectionView.indexPathsForSelectedItems{
                let newViewController = segue.destination as! APODDetailsViewController
                newViewController.apod = self.apods[indexPaths[0].row]
                collectionView.deselectItem(at: indexPaths[0], animated: false)
            }
        }
    }
    
    //    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        performSegue(withIdentifier: detailViewIdentifier, sender: self)
    //    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.apods.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! APODCell
        
        if !apods.isEmpty {
            cell.configure(apods[indexPath.row])
        }
        
        return cell
    }
    
}
// MARK: - Extensions
extension APODCollectionViewController {
    func loadData() {
        apiClient.getData(link: DataManager.shared.link, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apods):
                    print("Start Alamofire request")
                    self.apods = DataManager.shared.getSortedList(apods: apods)
                case .failure(let error):
                    print(error.localizedDescription)
                    self.apods = []
                }
                print("Reload collection")
                print(self.apods.count)
                self.collectionView.reloadData()
            }
        })
    }
}


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
