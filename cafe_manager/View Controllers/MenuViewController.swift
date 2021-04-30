//
//  MenuViewController.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-29.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class MenuViewController: UIViewController {
    
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    
    var imageData = Data()
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func createFoodItem() {
        let loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        loadingAlert.view.addSubview(loadingIndicator)
        present(loadingAlert, animated: true, completion: nil)
        
        
        storage.child("categories/\(self.txtName.text!).png").putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else {
                return
            }
            
            self.storage.child("categories/\(self.txtName.text!).png").downloadURL { (url, error) in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                print(urlString)
                
                let db = Firestore.firestore()
                
                db.collection("items").addDocument(data: [
                    "name": self.txtName.text!,
                    "description": self.txtDescription.text!,
                    "price": Float(self.txtPrice.text!) ?? 0,
                    "image": urlString,
                    "available":false
                ]
                )
                
                self.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Success!", message: "Food item saved successfully.", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                    
                    self.resetForm()
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
        
    }
    
    func resetForm() {
        txtName.text = ""
        txtDescription.text = ""
        txtPrice.text = ""
        imageView.image = nil
        imageData = Data()
    }
    
    
    @IBAction func didTapSelectImageBtn() {
        let pc = UIImagePickerController()
        pc.sourceType = .photoLibrary
        pc.delegate = self
        pc.allowsEditing = true
        present(pc, animated: true)
    }
    
    @IBAction func didTapSaveFoodItem() {
        //validate
        
        createFoodItem()
        
    }
    
}

extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageView.image = image
            
            guard let imageData = image.pngData() else {
                return
            }
            
            self.imageData = imageData
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
