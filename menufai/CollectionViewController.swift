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
        
//        EZLoadingActivity.show("loading...", disableUI: false)
        
//        var postObject = PFObject(className: "collectionView")
//        postObject.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
//            if error == nil {
//                if succeeded == true {
//                    EZLoadingActivity.hide(success: true, animated: false)
//                    print("Upload Complete")
//                } else {
//                    EZLoadingActivity.hide(success: false, animated: true)
//                    print("Upload Failed")
//                }
//            } else {
//                EZLoadingActivity.hide(success: false, animated: true)
//                print("Error")
//            }
//        }
//        EZLoadingActivity.hide(success: true, animated: false)
//        print("load Complete")
//        let lpgr = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
//        lpgr.minimumPressDuration = 0.5
//        lpgr.delaysTouchesBegan = true
//        lpgr.delegate = self
//        self.collectionViewft.addGestureRecognizer(lpgr)
        
        MenufaiViewController().clearValues()
    }
    
    override func viewDidAppear(animated: Bool) {
       // EZLoadingActivity.show("Loading...", disableUI: true)
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
        
        //        if let temp = NSURL(string: filePath[0]) {
        //        print(temp)
        //        cell.foodImage.setImageWithURL(temp)
        //        }
//        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
////            print("SDWEBIMAGE \(self)")
//        }
        let tempString = menuLinkArray[indexPath.row] as String
        var temp = NSURL(string: tempString)
//        var data = NSData(contentsOfURL: temp!)
        
//        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//        dispatch_async(dispatch_get_global_queue(priority, 0)) {
//            // do some task
//            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
         
        if temp != nil {
            
//            let newImg = UIImage(data: data!)
            
//            if !imageArray.contains(tempString) {
//                print("Adding new img: \(temp)")
//                imageArray.append(tempString)
//            }
            
//            cell.resultImageView.image = UIImage(data: data!)
//            if indexPath.row < self.imageArray.count && self.imageArray.contains(tempString) {
//                print("Already have img")
//                let haveImgStr = self.imageArray[indexPath.row]
//                temp = NSURL(string: haveImgStr)
//                data = NSData(contentsOfURL: temp!)
//                cell.resultImageView.image = UIImage(data: data!)
//            }
//            else {
//                cell.resultImageView.sd_setImageWithURL(temp, placeholderImage: UIImage(named: "placeholder"), completed: block)
            cell.resultImageView.setImageWithURL(temp!, placeholderImage: UIImage(named: "placeholder"))
//                print("Don't have img")
//                print("Adding new img: \(temp)")
//                self.imageArray.append(tempString)
//            }
        }
//            }
//        }
        cell.foodLabel.text = menuItems[indexPath.row]
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        //        cell.foodImage.setImageWithURL(temp)
        //
        //        } else {
        //            print("not working")
        //        }
        //        for imageLink in self.filePath {
        //            //print(imageLink)
        //            let temp = NSURL(string: imageLink)!
        //            cell.foodImage.setImageWithURL(temp)
        //            //cell.foodImage.image = NSURL(string: imageLink)
        //        }
        return cell
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.Ended {
            self.infoView.hidden = false
            
            let p = gestureReconizer.locationInView(self.collectionViewft)
            let indexPath = self.collectionViewft.indexPathForItemAtPoint(p)
            
            if let index = indexPath {
                var cell = self.collectionViewft.cellForItemAtIndexPath(index) as! CollectionViewCell
                // do stuff with your cell, for example print the indexPath
                print("\(index.row): I clicked on a \(cell.foodLabel.text!)")
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
                
                
                print(menuNutrition[index.row])
                
                
            } else {
                print("Could not find index path")
            }
            
            return
        }
        
        
        self.infoView.hidden = true
    }
    
}
