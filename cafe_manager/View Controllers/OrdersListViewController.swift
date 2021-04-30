//
//  OrdersListViewController.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-26.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import UserNotifications

class OrdersListViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet weak var tblItems: UITableView!
    
    @Published var items = [Order]()
    @Published var tableOrders = [[Order]]()
    var isInitial = true
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrders {
            self.tblItems.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: [])
        
        tblItems.rowHeight = 70
        tblItems.delegate = self
        tblItems.dataSource = self
        
        
        let db = Firestore.firestore()
        
        db.collection("orders").addSnapshotListener { snapshot, error in
            guard let _ = snapshot?.documents, error == nil else {
                return
            }
            
            
            snapshot?.documentChanges.forEach { diff in if (diff.type == .added) {
                if(snapshot?.documentChanges.count == 1) {
                    self.showNotification(title: "New order receieved!", body: "New order receieved.")
                    self.fetchOrders {
                        self.tblItems.reloadData()
                    }
                }
                
            }
            if (diff.type == .modified) {
                self.showNotification(title: "Order updated!", body: "Order status updated to - \(diff.document.data()["status"] as! String)")
                self.fetchOrders {
                    self.tblItems.reloadData()
                }
                
            }
            
            }
        }
    }
    
    func showNotification(title:String, body:String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        
        center.add(request) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
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
