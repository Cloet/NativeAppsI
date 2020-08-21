//
//  LotCell.swift
//  auction
//
//  Created by mathias cloet on 08/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class LotCell : UITableViewCell {
    
    // The current lot
    var lot : Lot?
    
    // Imageview, labels, button
    @IBOutlet weak var lotImage: UIImageView!
    @IBOutlet weak var lotTitleLabel: UILabel!
    @IBOutlet weak var lotHighestBid: UILabel!
    @IBOutlet weak var lotBidButton: RoundedButton!
    @IBOutlet weak var lotCellContainer: UIView!
    @IBOutlet weak var lotFavoriteButton: UIButton!
    
    // Toggle favorited status of a lot.
    @IBAction func toggleFavorited(_ sender: Any) {
        toggleFavorite()
    }
    
    // Callbacks
    var onHighestBidder: (() -> ())?
    var onInfoClick: (() -> ())?
    var onBidClick: (() -> ())?
    
    // Bid on a lot.
    @IBAction func lotBid(_ sender: Any) {
        onBidClick?()
    }
    
    // Toggle the favorited status of a lot.
    func toggleFavorite() {
        guard let lot = self.lot else {
            fatalError("Ongeldig lot.")
        }
        if (!lot.highestBidder()) {
            lot.toggleFavorited()
            setFavoriteButtonIcon()
        } else {
            onHighestBidder?()
        }
    }
    
    func setup(lot: Lot) {
        self.setLot(lot: lot)
        self.setContainer()
    }
    
    // set border radius & shadows
    func setContainer() {
        
        lotBidButton?.BottomRightBorderRadius(radius: 20)
        
        lotCellContainer?.layer.borderWidth = 1
        lotCellContainer?.layer.cornerRadius = 20
                
        lotCellContainer?.layer.shadowPath = UIBezierPath(roundedRect: lotCellContainer.bounds, cornerRadius: 20).cgPath
        lotCellContainer?.layer.shadowRadius = 4
        lotCellContainer?.layer.shadowOffset = .zero
        lotCellContainer?.layer.shadowOpacity = 0.6
    }
    
    // Add ontap events on images.
    // Double tap to toggle favorited status.
    // Tap to go to detail.
    func setOnImageTap() {
        lotImage.isUserInteractionEnabled = true
        
        // Add tap
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tagGestureRecognizer:)))
        gesture.numberOfTapsRequired = 1
        lotImage.addGestureRecognizer(gesture)
        // Double tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTapped(tapGestureRecognizer:)))
        tap.numberOfTapsRequired = 2
        lotImage.addGestureRecognizer(tap)
        
        gesture.require(toFail: tap)
    }
    
    // Set the icon depending on the favorited status.
    func setFavoriteButtonIcon() {
        guard let lot = self.lot else {
            fatalError("Ongeldig lot.")
        }
        
        if (lot.alreadyPersisted()) {
            self.lotFavoriteButton?.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.lotFavoriteButton?.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    // Set all data of the lot.
    func setLot(lot: Lot) {
        self.lot = lot;
        
        setFavoriteButtonIcon()
        
        // Set the label text
        var prefix = "Startbod:"
        if (lot.currentBid != lot.openingsBid) {
            prefix = "Hoogste bod:"
        }
        
        lotTitleLabel.text = self.lot?.title
        lotHighestBid.text = "\(prefix) € " + String(format: "%.2f",self.lot?.currentBid ?? 0)
        
        // Init the image as nil -> images can glitch otherwise
        lotImage.image = nil
        
        // Load the first image from the lot image array
        if (lot.images.first?.id ?? -1 > 0) {
            AuctionAPI().getLotImage(lotId: lot.id, imageId: lot.images.first!.id, completion: { (data) in
                guard let data = data else {return}
                DispatchQueue.main.async {
                    self.lotImage.image = data
                    self.setOnImageTap()
                    self.lotImage.TopLeftRightRadius(radii: 20)
                }
            })
        }
    }
    
    @objc func imageTapped(tagGestureRecognizer: UITapGestureRecognizer) {
        onInfoClick?()
    }
    
    @objc func imageDoubleTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        toggleFavorite()
    }

    
    
}


