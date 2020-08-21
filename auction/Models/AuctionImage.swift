//
//  AuctionImage.swift
//  auction
//
//  Created by mathias cloet on 03/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation

class AuctionImage: Decodable {
    var auctionID: Int = 0
    var id: Int = 0
    var imageLocation: String = ""
    var aspectRatio: Double = 1.0
}
