//
//  ViewController.swift
//  menufai
//
//  Created by Varun Vyas on 23/01/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//

import UIKit
import TesseractOCR

class MenufaiViewController: UIViewController,G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var dishName = ""
    var menu: [NSDictionary]?
    var menulinkArray : [String] = []
    var filePath :[String] = []
    var theImage: UIImage?
    var menuString: [String] = []
    var menuNutrition: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)

        let tesseract:G8Tesseract = G8Tesseract(language:"eng+fra");
        tesseract.language = "eng+fra";

        //var tesseract:G8Tesseract = G8Tesseract(language:"eng+ita");
        /*
        let tesseract:G8Tesseract = G8Tesseract(language:"eng");
        
        tesseract.language = "eng";
        tesseract.delegate = self;
        tesseract.engineMode = .TesseractCubeCombined
        
        tesseract.charWhitelist = "abcdefghijklmnopqrstwxyz0123456789ABCDEFGHIJKLMNOPQRSTWXYZ.$";

        tesseract.pageSegmentationMode = .Auto
        
        tesseract.maximumRecognitionTime = 60.0

        tesseract.image = UIImage(named: "frenchMenu1");
        tesseract.recognize();
        print(tesseract.recognizedText);
        //tesseract.image = UIImage(named: "MenuBarton");
        tesseract.image = self.theImage
        tesseract.recognize();
        tesseract.recognizedText.enumerateLines { (line, stop) -> () in
            if(!line.isEmpty){
                //let temp = line.componentsSeparatedByString(" ")
                self.filter(line)
            
                print(line)
                //let separated = split("Split Me!", {(c:Character)->Bool in return c==" "}, allowEmptySlices: false)
            }
            //print("Hi")
        }
        //NSLog("%@", tesseract.recognizedText);
        /*Make a array of string and loop over it
        and query for each function and get the url
        and then make a Array of String of URL
        We will use that Array of String to make our String*/
//        let menuArray = ["Burger" , "Pizza" , "Hotdog" , "spaghetti"]
//        for menu in menuArray {
//            let temp = networkRequest(menu)
//            print(temp)
//            self.menulinkArray.append(temp)
//        }
        
        dishName = "Burger"
       // getImage()
        */
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func filter(line :String)->[String] {
        let temp = line.componentsSeparatedByString(" ")
    //    print("filtering -  " + line)
        
        print( matchesForRegexInText("/^[A-Za-z]+$/", text: line ) )
        
        var listOfNames :[String] = [""] // an array of strings
        for words in temp {
            
            if(words.characters.count>2 && !words.characters.contains("$"))
            {
                //print(words)
//                listOfNames.append(words)
                //print( matchesForRegexInText("/^[A-Za-z]+$/", text : words ) )
            }
//            if(words.containsString("abcdefghijklmnopqrstwxyzABCDEFGHIJKLMNOPQRSTWXYZ")) {
//                print(words)
//            }
//            
        }
        return listOfNames
    }
    

    func networkRequest(menuName :String) -> String {
        var cx = "011903584210993207937:bz3dg769ssy"
        var key = "AIzaSyCUXq0S6_wp1AtZy2vLNDpVCV1Opsapu1M"
        var u = "https://www.googleapis.com/customsearch/v1?cx=\(cx)&q=\(menuName)&key=\(key)&searchType=image"
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
                        //print(result)
                        self.menu = result["items"] as? [NSDictionary]
                        if self.menu != nil {
                            for dic in self.menu! {
                                if let linkData = dic["link"] as? String {
                                    self.filePath.append(linkData)
                                    //print(filePath)
                                    return linkData
                                }
                            }
                        }
                        else {
                            print("Nothing found for this item: \(menuName)")
                        }
                        
                    }
                    else {
                        print("No Working ")
                    }
                }
            }
        }catch {
            print("Error!")
        }
        return linkData
    }
    
    func requestNutrition(menuItem: String) {
        let appId = "f043c24d"
        let appKey = "8897be9dbacaa535e0cba2ea6b4d4d44"
        var escapedItem = menuItem.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        var search = "https://api.nutritionix.com/v1_1/search/\(escapedItem!)?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat&appId=\(appId)&appKey=\(appKey)"
        print(search)
        let url = NSURL(string: search)!
        let request = NSURLRequest(URL: url)
        //var dictionary : [String:String] = [:]
        do {
            var responseObject:NSURLResponse?
            var err:NSErrorPointer = NSErrorPointer()
            let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &responseObject)
            if let response1 = responseData as NSData?{
                if(err == nil) {
                    if let result = try NSJSONSerialization.JSONObjectWithData(response1, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        //print(result["hits"]![0]["fields"]!)
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
                        
                        /*
                        self.menu = result["items"] as? [NSDictionary]
                        if self.menu != nil {
                            for dic in self.menu! {
                                if let linkData = dic["link"] as? String {
                                    self.filePath.append(linkData)
                                    //print(filePath)
                                    return linkData
                                }
                            }
                        }

                        else {
                            print("Nothing found for this item: \(menuItem)")
                        }
*/
                        
                    }
                    else {
                        print("No nutrition info found")
                        self.menuNutrition.append([:])
                    }
                }
            }
        }catch {
            print("Error!")
        }
        //return dictionary as NSDictionary

        
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            self.theImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            let tesseract:G8Tesseract = G8Tesseract(language:"eng");
            
            tesseract.language = "eng";
            tesseract.delegate = self;
            tesseract.engineMode = .TesseractCubeCombined
            
            tesseract.charWhitelist = "abcdefghijklmnopqrstwxyz0123456789ABCDEFGHIJKLMNOPQRSTWXYZ.$";
            
            tesseract.pageSegmentationMode = .Auto
            
            tesseract.maximumRecognitionTime = 60.0
            
            //tesseract.image = UIImage(named: "MenuBarton");
            tesseract.image = self.theImage
            tesseract.recognize();
            tesseract.recognizedText.enumerateLines { (line, stop) -> () in
                if(!line.isEmpty){
                    //let temp = line.componentsSeparatedByString(" ")
                    self.filter(line)
                    
                    //print(line)
                    self.menuString.append(line)
                    //let separated = split("Split Me!", {(c:Character)->Bool in return c==" "}, allowEmptySlices: false)
                }
                //print("Hi")
            }
            //NSLog("%@", tesseract.recognizedText);
            /*Make a array of string and loop over it
            and query for each function and get the url
            and then make a Array of String of URL
            We will use that Array of String to make our String*/
            let menuArray = self.menuString
            for menu in menuArray {
                let temp = networkRequest(menu)
                self.menulinkArray.append(temp)
                
                let nutrition = requestNutrition(menu)
            }
            
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
            
            performSegueWithIdentifier("resultView", sender: nil)
            

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
            //            let regex = try NSRegularExpression(pattern: regex, options: [])
            //             //
            //              let results = regex.matchesInString(text, options: [], range: NSMakeRange(0, nsString.length))
            //
            //            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return ""
        }
    }
    
//    func getImage() {
//        let url = NSURL(string: "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=\(dishName)")
//        let request = NSURLRequest(URL: url!)
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){ (response, go, error) -> Void in
//            do {
//            let go = NSJSONSerialization.JSONObjectWithData(go!, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]
//                let responseData = go["responseData"] as! [String:AnyObject]
//                print(responseData)
//
//            }
//            catch {
//                print("Error")
//            }
//            // let results = responseData["results"] as [String:AnyObject]
//            // let imageURL = results["unescapedUrl"] as String
//        }


}

//tesseract.charWhitelist = "01234567890";


