//
//  AuctionJSONDecoder.swift
//  auction
//
//  Created by mathias cloet on 20/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation

class AuctionJSONDecoder: JSONDecoder {
    
    override init() {
        super.init()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.dateDecodingStrategy = .formatted(dateFormatter)
        
    }
    
}
