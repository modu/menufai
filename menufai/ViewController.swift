//
//  ViewController.swift
//  menufai
//
//  Created by Varun Vyas on 23/01/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//

import UIKit


class ViewController: UIViewController,G8TesseractDelegate  {

    var dishName = ""
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
        tesseract.recognizedText.enumerateLines { (line, stop) -> () in
            if(!line.isEmpty){
                //let temp = line.componentsSeparatedByString(" ")
                self.filter(line)
            
                //print(line)
                //let separated = split("Split Me!", {(c:Character)->Bool in return c==" "}, allowEmptySlices: false)
            }
            //print("Hi")
        }
        //NSLog("%@", tesseract.recognizedText);
        
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
        var listOfNames :[String] = [""] // an array of strings
        for words in temp {
            words.stringByReplacingCharactersInRange(Range<1-4>, withString: "")
            if(words.characters.count>2 && words)
            {
                //print(words)
                listOfNames.append(words)
            }
//            if(words.containsString("abcdefghijklmnopqrstwxyzABCDEFGHIJKLMNOPQRSTWXYZ")) {
//                print(words)
//            }
//            
        }
        print(listOfNames)
        return listOfNames
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


