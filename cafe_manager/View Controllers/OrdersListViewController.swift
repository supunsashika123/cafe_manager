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
                
                //                self.spinner.stopAnimating()
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        if(section == 0){
//         return "New Orders"
//        }
//        if(section == 1){
//         return "Preparing"
//        }
//
//        if(section == 2){
//         return "Ready to pickup"
//        }
//
//        return "Other"
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? OrderDetailsViewController {
            destination.order = items[(tblItems.indexPathForSelectedRow?.row)!]
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemData = items[indexPath.row]
        
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
