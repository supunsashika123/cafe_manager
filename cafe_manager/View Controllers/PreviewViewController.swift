//
//  PreviewViewController.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-29.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class PreviewViewController: UIViewController {

    @IBOutlet weak var tblItems: UITableView!
    
    
    @Published var items = [FoodItem]()
    
    override func viewDidAppear(_ animated: Bool) {
        fetchItems{
            self.tblItems.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblItems.rowHeight = 70
        tblItems.delegate = self
        tblItems.dataSource = self
    }
    
    func fetchItems(completed:@escaping ()-> ()) {
        let db = Firestore.firestore()
        
        //        spinner.startAnimating()
        self.items = []
        
        db.collection("items").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting items: \(err)")
            } else {
                
                for itm in snapshot!.documents {
                    do {
                        let objItem = try itm.data(as: FoodItem.self)
                        
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
    
}


extension PreviewViewController: UITableViewDelegate {
    
}


extension PreviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemData = items[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodItemsTableCell
    
        cell.configure(with: itemData)
        cell.delegate = self
        
        cell.lblName?.text =  itemData.name
        cell.lblDescription?.text = itemData.description
        
        cell.lblPrice?.text = "LKR \(String(format: "%.2f", itemData.price))"
        cell.switchIsAvailable.isOn = itemData.available
        
        let url = URL(string: itemData.image)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
            
                cell.foodItemImageView.image = image
            }
            
        }
        
        task.resume()
        
        return cell
        
    }
}

extension PreviewViewController: FoodItemsTableCellDeletage {
    func onAvailablityUpdate(with item: FoodItem) {
        let db = Firestore.firestore()
        
        print(!item.available)
        
        db.collection("items").document(item.id!).setData(["available":!item.available],merge: true)
        
        fetchItems{
            self.tblItems.reloadData()
        }
    }
}

class FoodItemsTableCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var foodItemImageView: UIImageView!
    @IBOutlet weak var switchIsAvailable: UISwitch!
    @IBOutlet weak var wrapperView: UIView!
    
    weak var delegate: FoodItemsTableCellDeletage?
    
    var tableRowItem: FoodItem?
    
    func configure(with item:FoodItem) {
        self.tableRowItem = item
    }
    
    @IBAction func onAvailablityUpdate (){
        delegate?.onAvailablityUpdate(with: tableRowItem!)
    }
    
}

protocol FoodItemsTableCellDeletage: AnyObject {
    func onAvailablityUpdate(with item: FoodItem)
}

