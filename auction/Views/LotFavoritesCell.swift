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

class LotFavoritesCell: LotCell {
    
    var favLot: FavoriteLot?
    var onLotRemoved: (() -> ())?
    
    @IBOutlet weak var lotDeleteButton: RoundedButton!
    @IBOutlet weak var lotMyBid: UILabel!
    
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
    
    // Remove lot from realm
        
    override func setLot(lot: Lot) {
        super.setLot(lot: lot)
        lotMyBid.text = "Mijn bod: € " + String(format: "%.2f", self.favLot?.myBid ?? 0)
    }
    
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
