//
//  Lot.swift
//  auction
//
//  Created by mathias cloet on 05/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import RealmSwift

class Lot: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var auctionID: Int = 0
    @objc dynamic var number: Int = 0
    @objc dynamic var title: String? = ""
    @objc dynamic var overview: String? = ""
    @objc dynamic var startTime: Date? = nil
    @objc dynamic var endTime: Date? = nil
    @objc dynamic var LastBid: Date? = nil
    @objc dynamic var openingsBid: Double = 0.0
    @objc dynamic var currentBid: Double = 0.0
    @objc dynamic var amountOfBids: Int = 0
    @objc dynamic var bid: Double = 0.0
    var images: [LotImage] = []
    
    func toggleFavorited() {
        
        if (alreadyPersisted()) {
            deleteFavorite()
        } else {
            persistToRealm()
        }
        
    }
    
    func highestBidder() -> Bool {
        let favLot = getFavoritedLot(lotId: self.id)
        if (favLot != nil && favLot?.myBid == self.currentBid) {
            return true
        }
        return false
    }
    
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
    
    func getFavoritedLot(lotId: Int) -> FavoriteLot? {
        let realm = try! Realm()
        let lot = realm.objects(FavoriteLot.self).filter("lotId = \(lotId)").first
        return lot
    }
    
    func deleteFavorite() {
        let realm = try! Realm()
        
        let favLot = getFavoritedLot(lotId: self.id)
        guard let lot = favLot else {
            fatalError("No favorited lot found.")
        }
        
        // lot kan niet verwijderd worden als je het hoogste bod hebt.
        if (self.currentBid == lot.myBid) {
            return
        }
        
        try! realm.write {
            realm.delete(lot)
        }
    }
    
    func alreadyPersisted() -> Bool {
        if (self.id <= 0) {
            fatalError("Ongeldig lot.")
        }
        let lot = getFavoritedLot(lotId: self.id)
        return (lot != nil)
    }
    
    func convertToFavoriteLot() -> FavoriteLot {
        if (self.id <= 0) {
            fatalError("ongeldig lot.")
        }
        
        let favLot = FavoriteLot.init(id: self.id, bid: 0, ratio: self.images.first?.aspectRatio ?? 1.0)
        
        return favLot
    }
    
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
    
    func persistToRealm() {
        persistToRealmBid(bid: 0.0)
    }
    
}
