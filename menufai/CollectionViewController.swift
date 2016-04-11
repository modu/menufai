//
//  collectionViewController.swift
//  menufai
//
//  Created by Varun Vyas on 24/01/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//

import UIKit
import EZLoadingActivity
import AFNetworking

class CollectionViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    var menuLinkArray: [String]=[]
    var menuItems: [String] = []
    var menuNutrition: [NSDictionary] = []
    var imageArray: [String] = []
    
    @IBOutlet weak var collectionViewft: UICollectionView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nutritionLabel: UILabel!
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewft.delegate = self
        collectionViewft.dataSource = self
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionViewft.addGestureRecognizer(lpgr)
        
        MenufaiViewController().clearValues()
    }
    
    override func viewDidAppear(animated: Bool) {
        EZLoadingActivity.showWithDelay("Loading...", disableUI: false, seconds:0.5)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if( menuLinkArray.isEmpty )
        {
            return 0
        }
        else
        {
            return menuLinkArray.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        let tempString = menuLinkArray[indexPath.row] as String
        let temp = NSURL(string: tempString)
         
        if temp != nil {
            cell.resultImageView.setImageWithURL(temp!, placeholderImage: UIImage(named: "placeholder"))
        }
        
        cell.foodLabel.text = menuItems[indexPath.row]
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale

        return cell
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.Ended {
            self.infoView.hidden = false
            
            let p = gestureReconizer.locationInView(self.collectionViewft)
            let indexPath = self.collectionViewft.indexPathForItemAtPoint(p)
            
            if let index = indexPath {
                var cell = self.collectionViewft.cellForItemAtIndexPath(index) as! CollectionViewCell
                self.nameLabel.text = "Menu Item: \(cell.foodLabel.text!)"
                self.foodImageView.image = cell.resultImageView.image
                
                if menuNutrition[index.row] != [:] {
                    self.nutritionLabel.text = "\(menuNutrition[index.row]["item_name"]!) facts from \(menuNutrition[index.row]["brand_name"]!) \n" +
                        "Calories: \(menuNutrition[index.row]["nf_calories"]!) cal \n" +
                        "Total Fat: \(menuNutrition[index.row]["nf_total_fat"]!) g \n"
                }
                else {
                    self.nutritionLabel.text = "No nutritional values found"
                }
                
            } else {
                print("Could not find index path")
            }
            
            return
        }
        self.infoView.hidden = true
    }
    
}
