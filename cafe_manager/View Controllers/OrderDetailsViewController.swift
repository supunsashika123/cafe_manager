//
//  OrderDetailsViewController.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-29.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var order:Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = false

        print(order!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        
        lblDate.text = "Date - \(dateFormatter.string(from: order.date))"
        lblStatus.text = "Status - \(order.status)"
        lblTotalPrice.text = "Total Price - LKR \(String(format: "%.2f", order.total_price))"
        
        
        for i in 0..<order!.items.count {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = "\(order!.items[i].name) || \(order!.items[i].qty) || LKR \(String(format: "%.2f", order!.items[i].total))"
            
            stackView.addArrangedSubview(label)
            
        }
    }
    
    @IBAction func backBtnPress(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
