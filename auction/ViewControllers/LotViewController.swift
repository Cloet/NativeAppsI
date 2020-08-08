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
        
        AuctionAPI().getLots(auctionId: auction!.id, completion: { (data) in
            guard let data = data else { return }
            self.lots = data
            DispatchQueue.main.async {
                self.lotTableView.reloadData()
            }
        })
                
        lotTableView.delegate = self
        lotTableView.dataSource = self
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! LotDetailController
        controller.lot = (sender as! LotCell).lot
    }
        
}

extension LotViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lot = lots[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotCell") as! LotCell
        
        cell.setLot(lot: lot)
        
        cell.onClick = { [weak self] in
            self?.performSegue(withIdentifier: "showLotDetail", sender: cell)
        }
        
        return cell
    }
    
    
}
