//
//  LotViewController.swift
//  auction
//
//  Created by mathias cloet on 05/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

// Show list of all lots
class LotViewController : UIViewController {
    
    // The parent auction
    var auction: Auction?
    
    // connected labels
    @IBOutlet weak var auctionTitle: UILabel!
    @IBOutlet weak var auctionDescription: UILabel!
    @IBOutlet weak var lotTableView: UITableView!
    
    var lots: [Lot] = []

    // Load all data
    func LoadData() {
        AuctionAPI().getLots(auctionId: auction!.id, completion: { (data) in
            guard let data = data else { return }
            self.lots = data
            DispatchQueue.main.async {
                self.lotTableView.reloadData()
                self.lotTableView.sizeHeaderToFit()
            }
        })
    }
    
    // Refreshed data of the controller
    func RefreshData() {
        auctionTitle?.text = auction?.title
        auctionDescription?.text = auction?.overview
        lotTableView?.sizeHeaderToFit()
        
        LoadData()
    }
    
    // Called when the view has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RefreshData()
        
        lotTableView?.AddRefreshControl(target: self, action: #selector(self.refresh(sender:)))
        lotTableView?.delegate = self
        lotTableView?.dataSource = self
        lotTableView?.separatorStyle = .none
                
    }
    
    // Refresh event
    @objc func refresh(sender: UIRefreshControl?) {
        RefreshData()
        sender?.endRefreshing()
    }
    
    // Navigation override.
    // Based on the identifier reload specific data.
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
                controller.onRefresh = { [weak self] in
                    self?.RefreshData()
                }
            }
        }
    }
        
}

extension LotViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataAvailable(tableView: tableView, hasData: (lots.count > 0))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lots.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let lot = lots[indexPath.row]
        
        // The aspectratio is stored in the database.
        // With the aspectratio and width the correct height can be calculated.
        let ratio = lot.images.first?.aspectRatio ?? 1.0
        
        var newHeight = CGFloat(tableView.bounds.width * CGFloat(ratio))
                        
        // Set a maximum height for the images, the maxheight is different for ipad and phone
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            if newHeight > 500 {
                newHeight = 500
            }
        } else {
            if newHeight > 350 {
                newHeight = 350
            }
        }
        
        // The calculated height of the image + 100 for labels etc.
        return (newHeight+100)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lot = lots[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotCell") as! LotCell
        
        cell.setup(lot: lot)
        
        // Navigate to LotDetail
        cell.onInfoClick = { [weak self] in
            self?.performSegue(withIdentifier: "showLotDetail", sender: cell)
        }
        
        // Navigate to biddingcontroller
        cell.onBidClick = { [weak self] in
            self?.performSegue(withIdentifier: "showLotBid", sender: cell)
        }
        
        // Show an alert when the user is the highest bidder.
        cell.onHighestBidder = { [weak self] in
            self?.showOKAlert(title: lot.title ?? "Lot", message: "Dit lot kan niet verwijderd worden. U bent momenteel de hoogste bieder.")
        }
        
        
        return cell
    }
    
    
}
