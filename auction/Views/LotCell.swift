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
    
    var onClick: (() -> ())?
    @IBAction func LotDetails(_ sender: Any) {
        onClick?()
    }
    
    func setLot(lot: Lot) {
        self.lot = lot;
        lotTitleLabel.text = self.lot?.title
        lotHighestBid.text = "Hoogste bod: €\(self.lot?.currentBid ?? 0)"
        lotImage.image = nil
        
        if (lot.images.first?.id ?? -1 > 0) {
            AuctionAPI().getLotImage(lotId: lot.id, imageId: lot.images.first!.id, completion: { (data) in
                guard let data = data else {return}
                DispatchQueue.main.async {
                    self.lotImage.image = data
                }
            })
        }
    }
    
}
