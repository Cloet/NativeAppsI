//
//  LotImage.swift
//  auction
//
//  Created by mathias cloet on 08/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation

class LotImage: Decodable {
    var lotID: Int = 0
    var id: Int = 0
    var imageLocation: String = ""
    var aspectRatio: Double = 1.0
}
