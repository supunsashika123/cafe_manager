//
//  CategoryViewController.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-29.
//

import UIKit
import Firebase
import FirebaseFirestore

class CategoryViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet var tblCategories: UITableView!
    
    var categories = [Category]()
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCategories {
            self.tblCategories.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAdd.layer.cornerRadius = 20
        txtCategory.layer.borderWidth = 0.5
        txtCategory.layer.cornerRadius = 5
        updateButtonStatus(isEnabled: false)
                
        tblCategories.delegate = self
        tblCategories.dataSource = self
    }
    
    func updateButtonStatus(isEnabled:Bool) {
        btnAdd.isEnabled = isEnabled
        btnAdd.isUserInteractionEnabled = isEnabled
        btnAdd.alpha = isEnabled ? 1 : 0.5
    }
    
    func fetchCategories(completed:@escaping ()-> ()) {
        let db = Firestore.firestore()
        categories = []
        //        spinner.startAnimating()
        
        db.collection("categories").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for itm in snapshot!.documents {
                    do {
                        let objItem = try itm.data(as: Category.self)
                        self.categories.append(objItem!)
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
    
    func saveCategory() {
        let db = Firestore.firestore()
        
        db.collection("categories").addDocument(data: ["name":txtCategory.text!]) { (err) in
            
            if err != nil {
                print(err!.localizedDescription)
            }
            
            self.txtCategory.text = ""
            self.fetchCategories {
                self.tblCategories.reloadData()
            }
        }
    }

    @IBAction func onTextChange(_ sender:Any) {
        updateButtonStatus(isEnabled: (txtCategory.text != ""))
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        saveCategory()
    }
    
}



extension CategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = categories[indexPath.row]
        cell.textLabel?.text = item.name

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            
            print(categories[indexPath.row])
            deleteCategory(categoryId: categories[indexPath.row].id!)
            categories.remove(at: indexPath.row)
            
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
            
        }
    }
    
    func deleteCategory(categoryId:String) {
        let db = Firestore.firestore()
        
        db.collection("categories").document(categoryId).delete()
    }
}
