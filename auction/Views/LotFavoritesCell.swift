//
//  LotFavoritesCell.swift
//  auction
//
//  Created by mathias cloet on 12/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

// Inherits from LotCell
class LotFavoritesCell: LotCell {
    
    // The favorited lot
    var favLot: FavoriteLot?
    
    // Callback when a lot is removed.
    var onLotRemoved: (() -> ())?
    
    @IBOutlet weak var lotDeleteButton: RoundedButton!
    @IBOutlet weak var lotMyBid: UILabel!
    
    // Remove a lot.
    // Prevent deletion when you're the highest bidder.
    @IBAction func removeLot(_ sender: Any) {
        guard let lot = self.lot else {
            return
        }
        if (lot.highestBidder()) {
            onHighestBidder?()
        } else {
            lot.deleteFavorite()
            onLotRemoved?()
        }
    }
    
    override func toggleFavorite() {
        // Skip this event.
        // super.toggleFavorite()
        // onLotRemoved?()
    }
    
    override func setLot(lot: Lot) {
        super.setLot(lot: lot)
        lotMyBid.text = "Mijn bod: € " + String(format: "%.2f", self.favLot?.myBid ?? 0)
    }
    
    // Get the lot data.
    func setLotFavorite(favlot: FavoriteLot) {
        self.favLot = favlot
        
        self.setContainer()
        
        lotBidButton?.layer.cornerRadius = 0
        lotBidButton?.layer.mask = nil
        lotDeleteButton?.layer.cornerRadius = 0
        lotDeleteButton?.BottomRightBorderRadius(radius: 20)
        
        AuctionAPI().getLot(lotId: favlot.lotId, completion: { (data) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.setLot(lot: data)
            }
        })
        

    }
    
}
