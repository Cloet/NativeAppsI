//
//  AuctionListViewController.swift
//  
//
//  Created by mathias cloet on 02/08/2020.
//

import UIKit
import RealmSwift

// Homepage
// Shows a list of auctions.
class AuctionListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // The auctions items that are shown
    var auctions:  [Auction] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAuctions()
        
        // Adds a refreshcontrol
        tableView.AddRefreshControl(target: self, action: #selector(self.onRefresh(sender:)))
        
        // Bigger rowheigt for tablet
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            tableView.rowHeight = 450
        } else {
            tableView.rowHeight = 300
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
    
    // When changing from portrait to landscape on ipad -> image doesn't properly resize
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.tableView.reloadData()
    }
    
    @objc func onRefresh(sender: UIRefreshControl?) {
        self.setupAuctions()
        sender?.endRefreshing()
    }
    
    // Set the auction when navigating to the LotViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! LotViewController
        controller.auction = (sender as! AuctionCell).auction
    }
    
}


extension AuctionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Checks if no data is available.
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
        
        // Detect when an image is tapped, then navigate to detail.
        cell.onTap = { [weak self] indexPath in
            self?.performSegue(withIdentifier: "showAuctionDetail", sender: cell)
        }
        
        return cell
    }
    
    
}
