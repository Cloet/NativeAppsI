//
//  AuctionListViewController.swift
//  
//
//  Created by mathias cloet on 02/08/2020.
//

import UIKit

class AuctionListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var auctions:  [Auction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuctionAPI().getAuctions { (data) in
            guard let data = data else { return }
            self.auctions = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            tableView.rowHeight = 360
        } else {
            tableView.rowHeight = 245
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupNavBar()
    }
    
    func setupNavBar() {

        let label = UILabel()
        label.text = "veilingen"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! LotViewController
        controller.auction = (sender as! AuctionCell).auction
    }
    
}


extension AuctionListViewController: UITableViewDataSource, UITableViewDelegate {

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
