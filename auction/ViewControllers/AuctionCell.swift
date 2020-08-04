//
//  AuctionCell.swift
//  auction
//
//  Created by mathias cloet on 02/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class AuctionCell: UITableViewCell {
    
    @IBOutlet weak var auctionLabel: UILabel!
    @IBOutlet weak var auctionImageCollection: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    var images: [UIImage] = []
    
    func setAuction(auction: Auction) {
        // auctionLabel.text = auction.title
        
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth: -4.0,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .black)
        ] as [NSAttributedString.Key : Any]
        auctionLabel.attributedText = NSMutableAttributedString(string: auction.title ?? "", attributes: strokeTextAttributes)
        
        pageView.currentPage = 0
        
        auctionImageCollection.delegate = self
        auctionImageCollection.dataSource = self
        
        AuctionAPI().getImages(auction: auction, completion: { (data) in
            guard let data = data else  { return}
            self.images = data
            self.pageView.currentPage = 0
            DispatchQueue.main.async {
                self.auctionImageCollection.reloadData()
            }
            
        } )
        
    }
        
}

extension AuctionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageView?.currentPage = Int(auctionImageCollection.contentOffset.x) / Int(auctionImageCollection.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageView?.currentPage = Int(auctionImageCollection.contentOffset.x) / Int(auctionImageCollection.contentOffset.x)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageView.numberOfPages = images.count
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuctionImageCollectionCell", for: indexPath) as! AuctionCollectionCell

        let image = images[indexPath.row]
        cell.setImage(image: image)
        
        return cell
    }
}

extension AuctionCell: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = auctionImageCollection.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}


