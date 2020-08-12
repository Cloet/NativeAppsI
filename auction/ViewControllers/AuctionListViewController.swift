//
//  AuctionListViewController.swift
//  
//
//  Created by mathias cloet on 02/08/2020.
//

import UIKit

import RealmSwift

class AuctionListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var auctions:  [Auction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAuctions()
        tableView.AddRefreshControl(action: #selector(self.onRefresh(_:)))
                
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            tableView.rowHeight = 360
        } else {
            tableView.rowHeight = 245
        }
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        self.setupNavBar(text: "veilingen")
    }
    
    func setupAuctions() {
        AuctionAPI().getAuctions { (data) in
            guard let data = data else { return }
            self.auctions = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func onRefresh(_ sender: UIRefreshControl?) {
        self.setupAuctions()
        sender?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! LotViewController
        controller.auction = (sender as! AuctionCell).auction
    }
    
}


extension AuctionListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataAvailable(tableView: tableView, hasData: (auctions.count > 0))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auctions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let auction = auctions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuctionCell") as! AuctionCell
    
        cell.setAuction(auction: auction)
        
        cell.onTap = { [weak self] indexPath in
            self?.performSegue(withIdentifier: "showAuctionDetail", sender: cell)
        }
        
        return cell
    }
    
    
}
