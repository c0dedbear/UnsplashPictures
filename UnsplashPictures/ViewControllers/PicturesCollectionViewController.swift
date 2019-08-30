//
//  PicturesCollectionViewController.swift
//  UnsplashPictures
//
//  Created by Михаил Медведев on 29/08/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//

import UIKit

class PicturesCollectionViewController: UICollectionViewController {
    
    // MARK: Dependencies
    private let networkController = NetworkController()
    private let storageController = StorageController()
    private let cellController = CellController()
    
    // MARK: Properties
    private var loadingIndicator: UIActivityIndicatorView!
    
    private var pictures = [Picture](){
        didSet {
            storageController.save(pictures: pictures)
            collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    private var currentPage = 1
    private var fetchingMore = false
    
    // Properties for calculation colletionView cell's positions
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        configureNavigationBar()
        configureCollectionView()
        
        networkController.fetchPicturesInfo(page: currentPage) { pictures in
            guard let fetchedPictures = pictures else {
                self.pictures = self.storageController.load() ?? []
                self.loadingIndicator.stopAnimating()
                return
            }
            self.pictures = fetchedPictures
            self.loadingIndicator.stopAnimating()
        }
        
        
    }
    
    //MARK: Methods
    func fetchMorePictures() {
        fetchingMore = true
        self.loadingIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.currentPage += 1
            self.networkController.fetchPicturesInfo(page: self.currentPage) { pictures in
                guard let fetchedPictures = pictures else {
                    self.fetchingMore = false
                    self.loadingIndicator.stopAnimating()
                    return
                }
                self.pictures.append(contentsOf: fetchedPictures)
                self.fetchingMore = false
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
}

// MARK: - Configure Navigation Bar
extension PicturesCollectionViewController {
    private func configureNavigationBar() {
        let titleLabel = UILabel()
        let title = "UNSPLASH PICTURES"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        titleLabel.text = title
        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: loadingIndicator)
    }
}

// MARK: Configure CollectionView
extension PicturesCollectionViewController {
    private func configureCollectionView() {
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
    }
}

// MARK: Setup Loading Indicator
extension PicturesCollectionViewController {
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.color = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
    }
}

// MARK: - UICollectionViewDataSource
extension PicturesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureCell
        
        let picture = pictures[indexPath.item]
        DispatchQueue.main.async {
            cell.metaLabel.text = "\(picture.width) x \(picture.height)"
            self.cellController.setupCell(in: collectionView, for: indexPath, for: cell, using: picture)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PicturesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picture = pictures[indexPath.item]
        // Cells Aspect ratio calculations
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availibleWidth = view.frame.width - paddingSpace
        let widthPerItem = availibleWidth / itemsPerRow
        let height = CGFloat(picture.height) * widthPerItem / CGFloat(picture.width)
        
        return CGSize(width: widthPerItem, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UIScrollViewDelegate
extension PicturesCollectionViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 1.1 {
            if !fetchingMore {
                fetchMorePictures()
            }
        }
    }
}


 // MARK: - Navigation
extension PicturesCollectionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let pictureCell = sender as! PictureCell
            guard let indexPath = collectionView.indexPath(for: pictureCell) else { return }
            guard let rawImageURL = URL(string:pictures[indexPath.item].urls["raw"]!) else { return }
            
            let detailPictureViewController = segue.destination as! DetailPictureViewController
            detailPictureViewController.rawImageURL = rawImageURL
        }
    }
}


