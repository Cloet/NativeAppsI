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

    func RefreshData() {
        auctionTitle?.text = auction?.title
        auctionDescription?.text = auction?.overview
        
        auctionTitle?.sizeToFit()
        auctionDescription?.sizeToFit()
        
        lotTableView.tableHeaderView?.sizeToFit()
        lotTableView.tableHeaderView?.layoutIfNeeded()
            
        AuctionAPI().getLots(auctionId: auction!.id, completion: { (data) in
            guard let data = data else { return }
            self.lots = data
            DispatchQueue.main.async {
                self.lotTableView.reloadData()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RefreshData()
        
        lotTableView.delegate = self
        lotTableView.dataSource = self
        lotTableView.separatorStyle = .none
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showLotBid" {
                if let controller = segue.destination as? LotBiddingController {
                    controller.lot = (sender as! LotCell).lot
                    controller.onCallback = { [weak self] lot in
                        self?.RefreshData()
                    }
                }
            } else {
                let controller = segue.destination as! LotDetailController
                controller.lot = (sender as! LotCell).lot
            }
        }
    }
        
}

extension LotViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lots.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let lot = lots[indexPath.row]
        let ratio = lot.images.first?.aspectRatio ?? 1.0
        
        var newHeight = CGFloat(tableView.bounds.width * CGFloat(ratio))
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            if newHeight > 500 {
                newHeight = 500
            }
        } else {
            if newHeight > 350 {
                newHeight = 350
            }
        }
        
        return (newHeight+80)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lot = lots[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotCell") as! LotCell
        
        cell.setLot(lot: lot)
        
        cell.onInfoClick = { [weak self] in
            self?.performSegue(withIdentifier: "showLotDetail", sender: cell)
        }
        
        cell.onBidClick = { [weak self] in
            self?.performSegue(withIdentifier: "showLotBid", sender: cell)
        }
        
        
        return cell
    }
    
    
}
