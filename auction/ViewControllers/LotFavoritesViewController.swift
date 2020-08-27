//
//  LotFavoritesViewController.swift
//  auction
//
//  Created by mathias cloet on 12/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

// Show a list of all favorited lots
class LotFavoritesViewController: UIViewController {
    
    // All favorited lots
    var lots: [FavoriteLot] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar(text: "Favorieten")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.AddRefreshControl(target: self, action: #selector(self.refresh(sender:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RefreshData()
    }
    
    @objc func refresh(sender: UIRefreshControl?) {
        RefreshData()
        sender?.endRefreshing()
    }
    
    func RefreshData() {
        let realm = try! Realm()
        lots = realm.objects(FavoriteLot.self).map{$0}
        
        tableView?.reloadData()
    }
    
    // Navigate to biddingcontroler or detailcontroller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showLotBid" {
                if let controller = segue.destination as? LotBiddingController {
                    controller.lot = (sender as! LotFavoritesCell).lot
                    controller.onCallback = { [weak self] lot in
                        self?.RefreshData()
                        
                        guard let fav = lot.getFavoritedLot(lotId: lot.id) else {
                            return
                        }
                        (sender as! LotFavoritesCell).setLotFavorite(favlot: fav)
                    }
                }
            } else {
                let controller = segue.destination as! LotDetailController
                controller.lot = (sender as! LotFavoritesCell).lot
                controller.onRefresh = { [weak self] in
                    self?.RefreshData()
                }
            }
        }
    }
    
}

extension LotFavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataAvailable(tableView: tableView, hasData: (lots.count > 0))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lots.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let lot = lots[indexPath.row]
        let ratio = lot.imgRatio
        
        // calculate image height based on width and image aspectratio.
        var newHeight = CGFloat(tableView.bounds.width * CGFloat(ratio))
        
        // Maximum height of an image, depending on tablet or phone.
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            if newHeight > 500 {
                newHeight = 500
            }
        } else {
            if newHeight > 350 {
                newHeight = 350
            }
        }
        
        return (newHeight+180)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lot = lots[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotCell") as! LotFavoritesCell
        
        cell.setLotFavorite(favlot: lot)
        
        // When a lot is removed refresh the current list.
        cell.onLotRemoved = { [weak self] in
            self?.RefreshData()
        }
        
        // Show an alert when trying to delete the lot when you have the highest bid.
        cell.onHighestBidder = { [weak self] in
            self?.showOKAlert(title: cell.lot?.title ?? "Lot", message: "Kan dit lot niet verwijderen. U bent de hoogste bieder.")
        }
        
        // Navigate to details controller
        cell.onInfoClick = { [weak self] in
            self?.performSegue(withIdentifier: "showLotDetail", sender: cell)
        }
        
        // Navigate to bidding controller.
        cell.onBidClick = { [weak self] in
            self?.performSegue(withIdentifier: "showLotBid", sender: cell)
        }
        
        
        return cell
    }
    
    
}
