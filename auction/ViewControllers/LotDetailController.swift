//
//  LotDetailController.swift
//  auction
//
//  Created by mathias cloet on 08/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class LotDetailController: UIViewController {
    
    var lot: Lot?
    var images: [UIImage] = []
    
    // Tableview
    @IBOutlet weak var lotDetailTableview: UITableView!
    
    // Title + overview
    @IBOutlet weak var lotTitleLabel: UILabel!
    @IBOutlet weak var lotOverviewLabel: UILabel!

    // Labels amnt of bids
    @IBOutlet weak var lotOpeningsBid: UILabel!
    @IBOutlet weak var lotHighestBid: UILabel!
    @IBOutlet weak var lotBid: UILabel!
    @IBOutlet weak var lotMinBid: UILabel!
    @IBOutlet weak var lotAmntBids: UILabel!
        
    // Button
    @IBOutlet weak var lotBidButton: UIButton!
    
    @IBAction func lotBidButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showLotBid", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? LotBiddingController {
            controller.lot = self.lot
            controller.onCallback = { [weak self] lot in
                self?.lot = lot
                self?.setupLot()
            }
        }        
    }
    
    func setupLot() {
        lotTitleLabel.text = lot?.title
        lotOverviewLabel.text = lot?.overview
        
        lotOpeningsBid.text = "Openingsbod: € " + String(format: "%.2f", lot?.openingsBid ?? 0)
        lotHighestBid.text = "Hoogste bod: € " + String(format: "%.2f", lot?.currentBid ?? 0)
        lotBid.text = "Opbod: € " + String(format: "%.2f", lot?.bid ?? 0)
        lotAmntBids.text = "Aantal biedingen: \(lot?.amountOfBids ?? 0)"
        
        var nextBid = 0.0
        if let currentBid = lot?.currentBid, let openingsbid = lot?.openingsBid {
            if (lot?.amountOfBids == 0) {
                nextBid = openingsbid
            } else {
                if let bid = lot?.bid {
                    nextBid = currentBid+bid
                }
            }
        }
        lotMinBid.text = "Min. volgend bod: € " + String(format: "%.2f", nextBid)
        
        lotBidButton.layer.cornerRadius = 5
        
        AuctionAPI().getLotImages(lot: self.lot!, completion: { (data) in
            guard let data = data else {return}
            self.images = data
            DispatchQueue.main.async {
                self.lotDetailTableview.reloadData()
                self.sizeHeaderToFit()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLot()

        lotDetailTableview.delegate = self
        lotDetailTableview.dataSource = self
    }
    
    func sizeHeaderToFit() {
        if let headerView = lotDetailTableview.tableHeaderView {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            lotDetailTableview.tableHeaderView = headerView
        }
    }
    
}

extension LotDetailController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ratio = self.lot?.images[indexPath.row].aspectRatio ?? 1.0
        
        var newHeight = CGFloat(tableView.bounds.width * CGFloat(ratio))
             
        if newHeight > 400 {
            newHeight = 400
        }
        
        return newHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let img = images[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotDetailCell") as! LotDetailCell
        
        cell.setImage(img: img)
    
        return cell
    }
    
}
