//
//  LotViewController.swift
//  auction
//
//  Created by mathias cloet on 05/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class LotViewController : UIViewController {
    
    var auction: Auction?
    
    @IBOutlet weak var auctionTitle: UILabel!
    @IBOutlet weak var auctionDescription: UILabel!
    @IBOutlet weak var lotTableView: UITableView!
    
    var lots: [Lot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auctionTitle?.text = auction?.title
        auctionDescription?.text = auction?.overview
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
}
