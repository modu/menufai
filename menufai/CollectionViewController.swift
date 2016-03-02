//
//  collectionViewController.swift
//  menufai
//
//  Created by Varun Vyas on 24/01/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//

import UIKit


class CollectionViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    var menuLinkArray :[String]=[]
    var menuItems : [String] = []
    
    @IBOutlet weak var collectionViewft: UICollectionView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nutritionLabel: UILabel!
    @IBOutlet weak var factLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewft.delegate = self
        collectionViewft.dataSource = self
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionViewft.addGestureRecognizer(lpgr)
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
        let tempString = menuLinkArray[indexPath.row] as String
        print(indexPath.row)
        print(tempString)
        let temp = NSURL(string: tempString)
        let data = NSData(contentsOfURL: temp!)
        print(temp)
        if data != nil {
            cell.resultImageView.image = UIImage(data: data!)
        }
        cell.foodLabel.text = menuItems[indexPath.row]
        print("The text should be: \(menuItems[indexPath.row])")
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
                self.nameLabel.text = cell.foodLabel.text
                
                
            } else {
                print("Could not find index path")
            }
            
            return
        }
        
        
        self.infoView.hidden = true
    }
    
}
