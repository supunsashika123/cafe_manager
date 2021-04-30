//
//  AccountViewController.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-30.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class AccountViewController: UIViewController {

    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var tblOrders: UITableView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    
    let fromDate = Date()
    
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblOrders.delegate = self
        tblOrders.dataSource = self
        
        createDatePickers()
    }
    
    func createDatePickers(){
        let fromDatePicker = UIDatePicker()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtFromDate.text = formatter.string(from: Date())
        fromDatePicker.datePickerMode = .date
        fromDatePicker.addTarget(self, action: #selector(onFromDateChange(sender:)), for: UIControl.Event.valueChanged)
        fromDatePicker.frame.size = CGSize(width: 0, height: 250)
        txtFromDate.inputView = fromDatePicker

        let toDatePicker = UIDatePicker()
        txtToDate.text = formatter.string(from: Date())
        toDatePicker.datePickerMode = .date
        toDatePicker.addTarget(self, action: #selector(onToDateChange(sender:)), for: UIControl.Event.valueChanged)
        toDatePicker.frame.size = CGSize(width: 0, height: 250)
        txtToDate.inputView = toDatePicker
        
        
    }
    
    func applyDatefilters() {
        let db = Firestore.firestore()
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        let fromDate = dateFormatter.date(from: txtFromDate.text!)
        let toDate = dateFormatter.date(from: txtToDate.text!)
        
        orders = []
        var totalPrice: Float = 0
        
        db.collection("orders")
            .whereField("date", isGreaterThanOrEqualTo: fromDate!)
            .whereField("date", isLessThanOrEqualTo: toDate!)
            .getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for itm in snapshot!.documents {
                    do {
                        let objItem = try itm.data(as: Order.self)
                        totalPrice += objItem!.total_price
                        self.orders.append(objItem!)
                    } catch  {
                        print("parse error!")
                    }
                }
                self.tblOrders.reloadData()
                self.lblTotalPrice.text = "LKR \(String(format: "%.2f", totalPrice))"
            }
        }
        
    }
    
    @objc func onFromDateChange(sender: UIDatePicker) {
        view.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtFromDate.text = formatter.string(from: sender.date)
        
        applyDatefilters()
    }
    
    @objc func onToDateChange(sender: UIDatePicker) {
        view.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtToDate.text = formatter.string(from: sender.date)
        
        applyDatefilters()
    }
    
}


extension AccountViewController: UITableViewDelegate {
    
}


extension AccountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemData = orders[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordersSummaryCell", for: indexPath) as! OrdersSummaryTableCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        
        cell.lblDate?.text = dateFormatter.string(from: itemData.date)
        cell.lblPrice?.text = "LKR \(String(format: "%.2f", itemData.total_price))"
        cell.lblOrderId?.text = "Order ID - ###\(String(itemData.id!.suffix(4)))"
        
        return cell
        
    }
}


class OrdersSummaryTableCell: UITableViewCell {
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblOrderId: UILabel!
}
