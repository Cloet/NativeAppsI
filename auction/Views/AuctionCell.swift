//
//  AuctionCell.swift
//  auction
//
//  Created by mathias cloet on 02/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class AuctionCell: UITableViewCell {
    
    // Labels
    @IBOutlet weak var auctionTimeLeftLabel: UILabel!
    @IBOutlet weak var auctionLabel: UILabel!
    @IBOutlet weak var auctionImageCollection: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    // Images & auctions
    var images: [UIImage] = []
    var auction: Auction?
    
    // When an image is tapped.
    var onTap: ((IndexPath) -> Void)?=nil
    
    // Set the data of an auction.
    func setAuction(auction: Auction) {
        self.auction = auction
        

        UpdateAuctionTitleLabel()

        UpdateTimeLabel()

        // Sets the pageview to default 0
        pageView.currentPage = 0
        
        // Sets the delegate & datasource of the collectionview.
        auctionImageCollection.delegate = self
        auctionImageCollection.dataSource = self
        
        // Retrieve all images for the auction from api.
        AuctionAPI().getImages(auction: auction, completion: { (data) in
            guard let data = data else  { return}
            self.images = data
            self.pageView.currentPage = 0
            DispatchQueue.main.async {
                self.auctionImageCollection.reloadData()
            }
            
        } )
        
    }
    
    // Set the title label with specific markup.
    func UpdateAuctionTitleLabel() {
        // Label adding a stroke
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth: -4.0,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .black)
        ] as [NSAttributedString.Key : Any]
        auctionLabel.attributedText = NSMutableAttributedString(string: self.auction!.title ?? "", attributes: strokeTextAttributes)
    }
    
    // Calculate the time remaining for an auction and display it.
    func UpdateTimeLabel() {
        // Add rounded borders to the bottom & setting backgroundcolor to black
        auctionTimeLeftLabel.layer.backgroundColor = UIColor.black.cgColor
        auctionTimeLeftLabel.clipsToBounds = true
        auctionTimeLeftLabel.layer.cornerRadius = 5
        auctionTimeLeftLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        // enabling a timer that refreshes the time left for an auction
        auctionTimeLeftLabel.text = "" // placeholder text (otherwise there will be a second delay before the value is updated.
        
        // If the auction ends on this day refresh the timer every second, else only every minute.
        let diff = self.auction!.endDate?.timeIntervalSince(Date())
        let ti = NSInteger(diff!)

        
        let days = (ti / 3600) * 24
        
        UpdateTimeLeft()
        
        if (days <= 0) {
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.UpdateTimeLeft), userInfo: nil, repeats: true)
        }
        
    }
    
    // Called by Timer, updates the label of amount of time left for an auction.
    @objc func UpdateTimeLeft() {
        let diff = auction!.endDate!.timeIntervalSince(Date())
        
        if (diff < 0) {
            auctionTimeLeftLabel.text = "te laat"
        } else {
            auctionTimeLeftLabel.text = stringFromTimeInterval(interval: diff)
        }
        
    }
    
    // Convert timeinterval to a string.
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let ti = NSInteger(interval)
        
        let seconds = ti % 60
        let minutes = (ti/60) % 60
        let hours = (ti / 3600) % 24
        let days = (ti / (3600*24))
        
        if (days > 0) {
            return String("\(days)d \(hours)h \(minutes)m")
        }
        
        return String("\(hours)h \(minutes)m \(seconds)s ")
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTap?(indexPath)
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


