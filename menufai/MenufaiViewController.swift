//
//  ViewController.swift
//  menufai
//
//  Created by Varun Vyas on 23/01/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//
//import Foundation
import PKHUD
import AFNetworking
import UIKit
import EZLoadingActivity
import GPUImage

class MenufaiViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var dishName = ""
    var menu: [NSDictionary]?
    var menulinkArray : [String] = []
    var filePath :[String] = []
    var theImage: UIImage?
    var menuString: [String] = []
    var menuNutrition: [NSDictionary] = []
    static var camOn: Bool = false
    

    override func viewDidAppear(animated: Bool){
        if !MenufaiViewController.camOn {
            super.viewDidAppear(animated)
            
            dishName = ""
            menu = []
            menulinkArray = []
            filePath = []
            theImage = nil
            menuString = []
            menuNutrition = []
            
            
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //vc.sourceType = UIImagePickerControllerSourceType.Camera
    
            self.presentViewController(vc, animated: true, completion: nil)
            MenufaiViewController.camOn = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func filter(line :String)->[String] {
        let temp = line.componentsSeparatedByString(" ")
        
        print( matchesForRegexInText("/^[A-Za-z]+$/", text: line ) )
        
        var listOfNames :[String] = [""] // an array of strings
        for words in temp {
            
            if(words.characters.count>2 && !words.characters.contains("$"))
            {
                //print(words)
                listOfNames.append(words)
//                print( matchesForRegexInText("/^[A-Za-z]+$/", text : words ) )
            }
        }
        return listOfNames
    }
    
    
    func networkRequest(menuName :String) -> String {
        var cx = "011903584210993207937:bz3dg769ssy"
        //var key = "AIzaSyCUXq0S6_wp1AtZy2vLNDpVCV1Opsapu1M"
        //var key = "AIzaSyDxSZDvcBvCpUjw9pc5ZUAOpZ4k6VLM1MA"
        var key = "AIzaSyAvQF30x3dPnZXdzgvVLQM7o1H8_hFXSmw"
        //var key = "AIzaSyBEmdPIg-SFyJKG09UXB_tSuI0R1dvdJwg"
        var u = "https://www.googleapis.com/customsearch/v1?cx=\(cx)&q=\(menuName) &key=\(key)&searchType=image"

        var urlStr = u.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url = NSURL(string: urlStr)!
        let request = NSURLRequest(URL: url)
        let linkData = ""
        do {
            var responseObject:NSURLResponse?
            var err:NSErrorPointer = NSErrorPointer()
            let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &responseObject)
            if let response1 = responseData as NSData?{
                if(err == nil) {
                    if let result = try NSJSONSerialization.JSONObjectWithData(response1, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        self.menu = result["items"] as? [NSDictionary]
                        if self.menu != nil {
                            for dic in self.menu! {
                                if let linkData = dic["link"] as? String {
                                    self.filePath.append(linkData)
                                    return linkData
                                }
                            }
                        }
                        else {
                            print("No image found for this item: \(menuName)")
                        }
                        
                    }
                    else {
                        print("No Working ")
                    }
                }
            }
        }catch {
            print("networkRequest Error!")
        }
        return linkData
    }
    
    func requestNutrition(menuItem: String) {
        let appId = "f043c24d"
        let appKey = "8897be9dbacaa535e0cba2ea6b4d4d44"
        var escapedItem = menuItem.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        var search = "https://api.nutritionix.com/v1_1/search/\(escapedItem!)?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat&appId=\(appId)&appKey=\(appKey)"
        let url = NSURL(string: search)!
        let request = NSURLRequest(URL: url)
        
        do {
            var responseObject:NSURLResponse?
            var err:NSErrorPointer = NSErrorPointer()
            let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &responseObject)
            if let response1 = responseData as NSData?{
                if(err == nil) {
                    if let result = try NSJSONSerialization.JSONObjectWithData(response1, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        if result.count > 2 {
                            if result["total_hits"] as! Int != 0 {
                                self.menuNutrition.append(result["hits"]![0]["fields"]! as! NSDictionary)
                            }
                            else {
                                print("No nutrition info found")
                                self.menuNutrition.append([:])
                            }
                        }
                        else {
                            print("No nutrition info found")
                            self.menuNutrition.append([:])
                        }
                        
                        
                    }
                    else {
                        print("No nutrition info found")
                        self.menuNutrition.append([:])
                    }
                }
            }
        } catch {
            print("requestNutrition Error!")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {

            var scaledImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.theImage = scaledImage
            
            LoadingOverlay.shared.showOverlay(self.view)
            
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                print("This is run on the background queue")
                self.imageProcessing(self.theImage!)
                print("After Image Processing")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("This is run on the main queue, after the previous code in outer block")
                    LoadingOverlay.shared.hideOverlayView()
                    self.performSegueWithIdentifier("resultView", sender: nil)

                    picker.dismissViewControllerAnimated(true, completion: nil)

                })
            })

            
            func imagePickerControllerDidCancel(picker: UIImagePickerController) {
                dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    
    
    
    func imageProcessing(scaledImage :UIImage) {
        
        let adaptFilter = GPUImageAdaptiveThresholdFilter()
        adaptFilter.blurRadiusInPixels = 4.0
        
        var filteredImage = adaptFilter.imageByFilteringImage(scaledImage)

        print("After resizing seperately")
        print(filteredImage.size)
        
        while(filteredImage.size.height > 2400 || filteredImage.size.width > 2400 ) {
            filteredImage = filteredImage.resize(0.95)
            print(" Decreasing resolution  \(filteredImage.size)")
            
        }
        callOCRSpaceTest(filteredImage)
        
        let menuArray = self.menuString
        for menu in menuArray {
            let temp = networkRequest(menu)
            self.menulinkArray.append(temp)
            let nutrition = requestNutrition(menu)
        }


    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc = segue.destinationViewController as! CollectionViewController
        vc.menuLinkArray = menulinkArray
        vc.menuItems = menuString
        vc.menuNutrition = menuNutrition
        
    }
    
    
    
    func matchesForRegexInText(regex: String!, text :String!) -> String {
        do {
            
            let nsString = text as NSString;
            
            let strippedStr = text.stringByReplacingOccurrencesOfString("[^A-z ]+", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range:nil)
            
            return strippedStr
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return ""
        }
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func clearValues() {
        MenufaiViewController.camOn = false
    }
    
    func callOCRSpaceTest(img: UIImage) {
        
        let url = "https://api.ocr.space/Parse/Image"
        var imageData: NSData = UIImageJPEGRepresentation(img, 0.9)!
        var myImage = img;
        
        var parametersDictionary: [String : AnyObject] = ["apikey": "helloworld","isOverlayRequired": "True","language": "eng"]
        
        UPLOADIMG(url, parameters: parametersDictionary, filename: "test1.jpg", image: myImage, success: nil, failed: nil, errord: nil)
        
    }
    
    func UPLOADIMG(url: String,parameters: Dictionary<String,AnyObject>?,filename:String,image:UIImage, success:((NSDictionary) -> Void)!, failed:((NSDictionary) -> Void)!, errord:((NSError) -> Void)!) {
        
        var TWITTERFON_FORM_BOUNDARY:String = "AaB03x"
        let url = NSURL(string: url)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)
        var MPboundary:String = "--\(TWITTERFON_FORM_BOUNDARY)"
        var endMPboundary:String = "\(MPboundary)--"
        
        var fai: CGFloat = 1.0
        var data:NSData = UIImageJPEGRepresentation(image , 1.0)!
        var myImage = image
        while(data.length > 1000000 && fai > 0.3 ){
            
            data  = UIImageJPEGRepresentation(myImage, fai)!
            myImage = UIImage(data: data )!
            fai = fai - 0.10
            myImage =  myImage.resize(0.9)
        }
        
        var body:NSMutableString = NSMutableString();
        // with other params
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendFormat("\(MPboundary)\r\n")
                body.appendFormat("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendFormat("\(value)\r\n")
            }
        }
        // set upload image, name is the key of image
        body.appendFormat("%@\r\n",MPboundary)
        body.appendFormat("Content-Disposition: form-data; name=\"\(filename)\"; filename=\"pen111.png\"\r\n")
        body.appendFormat("Content-Type: image/png\r\n\r\n")
        var end:String = "\r\n\(endMPboundary)"
        var myRequestData:NSMutableData = NSMutableData();
        myRequestData.appendData(body.dataUsingEncoding(NSUTF8StringEncoding)!)
        myRequestData.appendData(data)
        myRequestData.appendData(end.dataUsingEncoding(NSUTF8StringEncoding)!)
        var content:String = "multipart/form-data; boundary=\(TWITTERFON_FORM_BOUNDARY)"
        request.setValue(content, forHTTPHeaderField: "Content-Type")
        request.setValue("\(myRequestData.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = myRequestData
        request.HTTPMethod = "POST"
        
        do {
            var responseObject:NSURLResponse?
            var err:NSErrorPointer = NSErrorPointer()
            let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &responseObject)
            if let response1 = responseData as NSData?{
                if(err == nil) {
                    if let result = try NSJSONSerialization.JSONObjectWithData(response1, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        
                        let parsedText: String = result["ParsedResults"]![0]!["ParsedText"]!! as! String
                        var parsedTextArr: [String] = []
                        
                        let lines = parsedText.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
                        for line in lines {
                            
                            if(!line.isEmpty){
                                self.filter(line)
                                let textLine = self.matchesForRegexInText("/^[A-Za-z]+$/", text: line )
                                let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
                                let trimmedString = textLine.stringByTrimmingCharactersInSet(whitespaceSet)
                                
                                if trimmedString != "" {
                                    self.menuString.append(trimmedString)
                                }
                            }
                        }
                        
                    }
                    else {
                        print("No Working ocrspace parsed text")
                    }
                }
            }
        }catch {
            print("UPLOADIMG Error!")
        }
        
        
        
    }
    
}


extension UIImage {
    func resize(scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    func resizeToWidth(width:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}


public class LoadingOverlay{
    
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        if  let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            let window = appDelegate.window {
                overlayView.frame = CGRectMake(0, 0, 120, 120)
                overlayView.center = CGPointMake(window.frame.width / 2.0, window.frame.height / 2.0)
                overlayView.backgroundColor = UIColor(hue: 0.0083, saturation: 1, brightness: 0.5, alpha: 1.0)
                overlayView.clipsToBounds = true
                overlayView.layer.cornerRadius = 10
                
                activityIndicator.frame = CGRectMake(0, 0, 80, 80)
                activityIndicator.activityIndicatorViewStyle = .WhiteLarge
                activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
                
                overlayView.addSubview(activityIndicator)
                window.addSubview(overlayView)
                
                activityIndicator.startAnimating()
        }
    }
    
    public func hideOverlayView() {
        
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}