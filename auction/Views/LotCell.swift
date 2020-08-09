//
//  LotCell.swift
//  auction
//
//  Created by mathias cloet on 08/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class LotCell : UITableViewCell, OnButtonPress {
    
    
    var lot : Lot?
    
    @IBOutlet weak var lotImage: UIImageView!
    @IBOutlet weak var lotTitleLabel: UILabel!
    @IBOutlet weak var lotHighestBid: UILabel!
    
    @IBOutlet weak var lotInfoButton: UIButton!
    @IBOutlet weak var lotBidButton: UIButton!
    @IBOutlet weak var lotCellContainer: UIView!
    
    var onUpdateConstraint: (() -> ())?
    var onClick: (() -> ())?
    @IBAction func LotDetails(_ sender: Any) {
        onClick?()
    }
    
    func setOnImageTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tagGestureRecognizer:)))
        lotImage.isUserInteractionEnabled = true
        lotImage.addGestureRecognizer(gesture)
    }
    
    func setLot(lot: Lot) {
        self.lot = lot;

        // Button cornerradius
        lotInfoButton.layer.cornerRadius = 5
        lotBidButton.layer.cornerRadius = 5
        
        // Set the label text
        var prefix = "Startbod:"
        if (lot.currentBid != lot.openingsBid) {
            prefix = "Hoogste bod:"
        }
        
        lotTitleLabel.text = self.lot?.title
        lotHighestBid.text = "\(prefix) €\(self.lot?.currentBid ?? 0)"
        
        // Init the image as nil -> images can glitch otherwise
        lotImage.image = nil
        
        // cornerradius 2
        lotCellContainer.layer.cornerRadius = 2        
        
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
        onClick?()
    }
    

    
    
}


