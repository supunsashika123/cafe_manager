//
//  OrdersListViewController.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-26.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class OrdersListViewController: UIViewController {
    @IBOutlet weak var tblItems: UITableView!
    
    @Published var items = [Order]()
    @Published var tableOrders = [[Order]]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrders {
            self.tblItems.reloadData()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tblItems.rowHeight = 70
        tblItems.delegate = self
        tblItems.dataSource = self
        
    }
    
    func fetchOrders(completed:@escaping ()-> ()) {
        let db = Firestore.firestore()
        
        //        spinner.startAnimating()
        self.items = []
        
        db.collection("orders").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for itm in snapshot!.documents {
                    do {
                        let objItem = try itm.data(as: Order.self)
                        
                        self.items.append(objItem!)
                    } catch  {
                        print("parse error!")
                    }
                }
                
                
                self.tableOrders = []
                for status in Constants.orderStatuses {
                    let aa = self.items.filter({
                        return $0.status == status
                    })
                    
                    
                    self.tableOrders.append(aa)
                }
                
                
                
                
                //                self.spinner.stopAnimating()
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }
    }

  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        
        if let destination = segue.destination as? OrderDetailsViewController {
            destination.order = tableOrders[(tblItems.indexPathForSelectedRow?.section)!][(tblItems.indexPathForSelectedRow?.row)!]
        }
    }
    
}


extension OrdersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == self.tblItems) {
            performSegue(withIdentifier: "showOrderDetails", sender: self)
        }

    }
    
}


extension OrdersListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.00
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.orderStatuses.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(tableOrders.count > section){
            return "\(Constants.orderStatuses[section]) (\(tableOrders[section].count))"
        } else {
            return Constants.orderStatuses[section]
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    
        if(tableOrders.count > section){
            return tableOrders[section].count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemData = tableOrders[indexPath.section][indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrdersTableCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        
        cell.title?.text = dateFormatter.string(from: itemData.date)
        cell.info?.text = "Status - \(itemData.status)"
        cell.price?.text = "LKR \(String(format: "%.2f", itemData.total_price))"
        
        return cell
        
    }
}



class OrdersTableCell: UITableViewCell {
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var info : UILabel!
    @IBOutlet weak var price : UILabel!
}
