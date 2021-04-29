//
//  OrderDetailsViewController.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-29.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class OrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnChangeStatus: UIButton!
    @IBOutlet weak var btnCancelOrder: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var order:Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = false
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        
        lblDate.text = "Date - \(dateFormatter.string(from: order.date))"
        lblStatus.text = "Status - \(order.status)"
        lblTotalPrice.text = "Total Price - LKR \(String(format: "%.2f", order.total_price))"
        
        if(order.status == "DONE" || order.status == "CANCELED") {
            btnChangeStatus.isHidden = true
            btnCancelOrder.isHidden = true
        } else {
            for (index, status) in Constants.orderStatuses.enumerated() {
                if(order.status == status) {
                    btnChangeStatus.setTitle("Change to \(Constants.orderStatuses[index+1])", for: .normal)
                }
            }
        }
         
        for i in 0..<order!.items.count {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = "\(order!.items[i].name) || \(order!.items[i].qty) || LKR \(String(format: "%.2f", order!.items[i].total))"
            
            stackView.addArrangedSubview(label)
            
        }
    }
    
    @IBAction func changeOrderStatusButtonClick(_ sender: Any) {
        for (index, status) in Constants.orderStatuses.enumerated() {
            if(order.status == status){
                updateStatus(newStatus: Constants.orderStatuses[index+1])
            }
        }
    }
    
    @IBAction func cancelOrderButtonClick(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation!", message: "Are you sure want to cancel this order?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel Order", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            self.updateStatus(newStatus: "CANCELED")
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func updateStatus(newStatus:String) {
        let db = Firestore.firestore()
        
        db.collection("orders").document(order.id!).setData(["status":newStatus],merge: true)
        
        let alert = UIAlertController(title: "Order status updated!", message: "Order status has been updated.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
}
