//
//  ViewController.swift
//  menufai
//
//  Created by Varun Vyas on 23/01/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//

import UIKit
import TesseractOCR

class MenufaiViewController: UIViewController,G8TesseractDelegate  {

    var dishName = ""
    var menu: [NSDictionary]?
    var menulinkArray : [String] = []
    var filePath :[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var tesseract:G8Tesseract = G8Tesseract(language:"eng+ita");
        
        let tesseract:G8Tesseract = G8Tesseract(language:"eng");
        tesseract.language = "eng";
        tesseract.delegate = self;
        tesseract.engineMode = .TesseractCubeCombined
        
        tesseract.charWhitelist = "abcdefghijklmnopqrstwxyz0123456789ABCDEFGHIJKLMNOPQRSTWXYZ.$";

        tesseract.pageSegmentationMode = .Auto
        
        tesseract.maximumRecognitionTime = 60.0
        
        tesseract.image = UIImage(named: "MenuBarton");
        tesseract.recognize();
        print(tesseract.recognizedText)
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
        let menuArray = ["Burger" , "Pizza" , "Hotdog" , "spaghetti"]
        for menu in menuArray {
            let temp = networkRequest(menu)
            print(temp)
            self.menulinkArray.append(temp)
        }
        
        dishName = "Burger"
       // getImage()
        
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
                        for dic in self.menu! {
                            if let linkData = dic["link"] as? String {
                                self.filePath.append(linkData)
                                //print(filePath)
                                return linkData
                            }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc = segue.destinationViewController as! CollectionViewController
        vc.menuLinkArray = menulinkArray
        
        print(menulinkArray)
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


