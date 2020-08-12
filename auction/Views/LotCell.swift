//
//  LotCell.swift
//  auction
//
//  Created by mathias cloet on 08/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class LotCell : UITableViewCell, OnInfoButtonPress, OnBidButtonPress {
    
    
    var lot : Lot?
    
    @IBOutlet weak var lotImage: UIImageView!
    @IBOutlet weak var lotTitleLabel: UILabel!
    @IBOutlet weak var lotHighestBid: UILabel!
    
    @IBOutlet weak var lotBidButton: RoundedButton!
    @IBOutlet weak var lotCellContainer: UIView!
        
    var onInfoClick: (() -> ())?
    var onBidClick: (() -> ())?
        
    @IBAction func lotBid(_ sender: Any) {
        onBidClick?()
    }
        
    func setOnImageTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tagGestureRecognizer:)))
        lotImage.isUserInteractionEnabled = true
        lotImage.addGestureRecognizer(gesture)
    }
        
    func setLot(lot: Lot) {
        self.lot = lot;
                
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
                }
            })
        }
    }
    
    @objc func imageTapped(tagGestureRecognizer: UITapGestureRecognizer) {
        onInfoClick?()
    }
    

    
    
}


