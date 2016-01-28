//
//  collectionViewController.swift
//  menufai
//
//  Created by Varun Vyas on 24/01/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//

import UIKit


class CollectionViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{

    var menuLinkArray :[String]=[]
    
    @IBOutlet weak var collectionViewft: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In CollectionViewController And will be printing menuLinkArray" )
        print(menuLinkArray)
        collectionViewft.delegate = self
        collectionViewft.dataSource = self
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if( menuLinkArray.isEmpty )
        {
            return 0
        }
        else
        {
            print("Value of File Parth alskdfjals; ;alskfj a ")
            print(menuLinkArray.count)
            return menuLinkArray.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("Hi in collectionVIew")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewController", forIndexPath: indexPath) as! CollectionViewCell
        print(menuLinkArray)
        //        if let temp = NSURL(string: filePath[0]) {
        //        print(temp)
        //        cell.foodImage.setImageWithURL(temp)
        //        }
        let tempString = menuLinkArray[2] as String
        let temp = NSURL(string: tempString)
        print(temp)
        //cell.fitImageView.setImageWithURL(temp!)
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
    
    
}
