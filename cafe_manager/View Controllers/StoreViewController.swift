//
//  StoreViewController.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-29.
//

import UIKit

class StoreViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var previewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.isHidden = true
        
    }
    
    @IBAction func switchViews(_ sender:UISegmentedControl) {
        
        categoryView.isHidden = true
        menuView.isHidden = true
        previewView.isHidden = true
        
        if sender.selectedSegmentIndex == 0 {
            previewView.isHidden = false
        } else if (sender.selectedSegmentIndex == 1) {
            categoryView.isHidden = false
        } else if (sender.selectedSegmentIndex == 2) {
            menuView.isHidden = false
        }
    }
    
}
