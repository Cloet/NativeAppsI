//
//  Lot.swift
//  auction
//
//  Created by mathias cloet on 05/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import RealmSwift
import Foundation

class Lot: Decodable {
    var id: Int = 0
    var auctionID: Int = 0
    var number: Int = 0
    var title: String? = ""
    var overview: String? = ""
    var startTime: Date? = nil
    var endTime: Date? = nil
    var LastBid: Date? = nil
    var openingsBid: Double = 0.0
    var currentBid: Double = 0.0
    var amountOfBids: Int = 0
    var bid: Double = 0.0
    var images: [LotImage] = []
    
    // Toggle favorited status
    func toggleFavorited() {
        if (alreadyPersisted()) {
            deleteFavorite()
        } else {
            persistToRealm()
        }
    }
    
    // Detect if you're the highest bidder
    func highestBidder() -> Bool {
        let favLot = getFavoritedLot(lotId: self.id)
        if (favLot != nil && favLot?.myBid == self.currentBid) {
            return true
        }
        return false
    }
    
    // Update your current bid on a lot.
    func updateFavoritedLotBid(bid: Double) {
        let favLot = getFavoritedLot(lotId: self.id)

        if (favLot != nil && favLot?.myBid != bid) {
            let realm = try! Realm()
            try! realm.write {
                favLot?.myBid = bid
            }
        } else {
            persistToRealmBid(bid: bid)
        }
    }
    
    // Get a favoritedlot from the database.
    func getFavoritedLot(lotId: Int) -> FavoriteLot? {
        let realm = try! Realm()
        let lot = realm.objects(FavoriteLot.self).filter("lotId = \(lotId)").first
        return lot
    }
    
    // Delete a favorited lot from the realm.
    func deleteFavorite() {
        let realm = try! Realm()
        
        let favLot = getFavoritedLot(lotId: self.id)
        guard let lot = favLot else {
            print("No favorited lot was found.")
            return
        }
        
        // lot kan niet verwijderd worden als je het hoogste bod hebt.
        if (self.currentBid == lot.myBid) {
            return
        }
        
        try! realm.write {
            realm.delete(lot)
        }
    }
    
    // Check if a lot is already persisted.
    func alreadyPersisted() -> Bool {
        if (self.id <= 0) {
            fatalError("Ongeldig lot.")
        }
        let lot = getFavoritedLot(lotId: self.id)
        return (lot != nil)
    }
    
    // Convert the current lot to a favorited lot.
    func convertToFavoriteLot() -> FavoriteLot {
        if (self.id <= 0) {
            fatalError("ongeldig lot.")
        }
        
        let favLot = FavoriteLot.init(id: self.id, bid: 0, ratio: self.images.first?.aspectRatio ?? 1.0)
        
        return favLot
    }
    
    // Persist a bid on a lot to the realm.
    func persistToRealmBid(bid: Double) {
        if (self.id <= 0) {
            fatalError("Ongeldig lot.")
        }
        
        if (alreadyPersisted()) {
            return
        }
        
        let realm = try! Realm()
        try! realm.write {
            let favLot = convertToFavoriteLot()
            favLot.myBid = bid
            realm.add(favLot)
        }
    }
    
    // Persist to realm without a bid.
    func persistToRealm() {
        persistToRealmBid(bid: 0.0)
    }
    
}
