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

class LotFavoritesViewController: UIViewController {
    
    var lots: [FavoriteLot] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar(text: "Favorieten")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let realm = try! Realm()
        lots = realm.objects(FavoriteLot.self).map{$0}
        
        tableView?.reloadData()
        
    }
    
}

extension LotFavoritesViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lots.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let lot = lots[indexPath.row]
        let ratio = lot.imgRatio ?? 1.0
        
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
        
        return (newHeight+180)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lot = lots[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotCell") as! LotFavoritesCell
        
        cell.setLotFavorite(favlot: lot)
        
        cell.onInfoClick = { [weak self] in
            self?.performSegue(withIdentifier: "showLotDetail", sender: cell)
        }
        
        cell.onBidClick = { [weak self] in
            self?.performSegue(withIdentifier: "showLotBid", sender: cell)
        }
        
        
        return cell
    }
    
    
}
