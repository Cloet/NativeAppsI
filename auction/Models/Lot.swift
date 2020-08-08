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
}
