//
//  ViewController.swift
//  menufai
//
//  Created by Varun Vyas on 23/01/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//

import UIKit
import TesseractOCR
import GPUImage

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
//        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
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
                listOfNames.append(words)
//                print( matchesForRegexInText("/^[A-Za-z]+$/", text : words ) )
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
                            print("No image found for this item: \(menuName)")
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
        print("Searching for: \(search)")
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
            var scaledImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.theImage = scaledImage
            //scaledImage = scaleImage(self.theImage!, maxDimension: 640)
            let adaptFilter = GPUImageAdaptiveThresholdFilter()
            adaptFilter.blurRadiusInPixels = 4.0
            
            let filteredImage = adaptFilter.imageByFilteringImage(scaledImage)
//            UIImageWriteToSavedPhotosAlbum(filteredImage, nil, nil, nil)
            
//            callOCRSpace(filteredImage)
            callOCRSpaceTest(filteredImage)
            
            
            /*
            let tesseract:G8Tesseract = G8Tesseract(language:"eng");
            print("imagePickerController got called");
            tesseract.language = "eng";
            tesseract.delegate = self;
            tesseract.engineMode = .TesseractCubeCombined
            
            //tesseract.charWhitelist = "abcdefghijklmnopqrstwxyz0123456789ABCDEFGHIJKLMNOPQRSTWXYZ.$";
            
            tesseract.pageSegmentationMode = .Auto
            
            tesseract.maximumRecognitionTime = 60.0
            
            //tesseract.image = UIImage(named: "MenuBarton");
            //tesseract.image = self.theImage
            tesseract.image = filteredImage
            tesseract.recognize();
            tesseract.recognizedText.enumerateLines { (line, stop) -> () in
                if(!line.isEmpty){
                    //let temp = line.componentsSeparatedByString(" ")
                    self.filter(line)
//                    print("The line is: \(line)")
                    //print(line)
                    let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
                    let trimmedString = line.stringByTrimmingCharactersInSet(whitespaceSet)
                    if trimmedString != "" {
//                        print("Line \(line) is added")
                        self.menuString.append(trimmedString)
                    }
//                    else {
//                        print("Did not add line")
//                        
//                    }
                    
                    
                    //let separated = split("Split Me!", {(c:Character)->Bool in return c==" "}, allowEmptySlices: false)
                }
                //print("Hi")
            }
            */
            
            
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
                //let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
                //let trimmedString = menu.stringByTrimmingCharactersInSet(whitespaceSet)
                //if trimmedString != "" {
                    //let nutrition = requestNutrition(trimmedString)
                //}
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
    
    func callOCRSpaceTest(img: UIImage) {
        
        let url = "https://api.ocr.space/Parse/Image"
        //        var data = "apikey=helloworld&isOverlayRequired=true&url=http://dl.a9t9.com/blog/ocr-online/screenshot.jpg&language=eng"
        var imageData: NSData = UIImageJPEGRepresentation(img, 0.6)!
        
        var parametersDictionary: [String : AnyObject] = ["apikey": "helloworld","isOverlayRequired": "True","language": "eng"]
        
        UPLOADIMG(url, parameters: parametersDictionary, filename: "test1.jpg", image: img, success: nil, failed: nil, errord: nil)
        
    }
    
    func UPLOADIMG(url: String,parameters: Dictionary<String,AnyObject>?,filename:String,image:UIImage, success:((NSDictionary) -> Void)!, failed:((NSDictionary) -> Void)!, errord:((NSError) -> Void)!) {
        var TWITTERFON_FORM_BOUNDARY:String = "AaB03x"
        let url = NSURL(string: url)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)
        var MPboundary:String = "--\(TWITTERFON_FORM_BOUNDARY)"
        var endMPboundary:String = "\(MPboundary)--"
        //convert UIImage to NSData
        var data:NSData = UIImagePNGRepresentation(image)!
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
        //        var conn:NSURLConnection = NSURLConnection(request: request, delegate: self)!

//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
//            data, response, error in
//            if error != nil {
//                print(error)
//                return
//            }

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
                                    //let temp = line.componentsSeparatedByString(" ")
                                    self.filter(line)
                                    //                    print("The line is: \(line)")

//                                    print(line)
                                    let textLine = self.matchesForRegexInText("/^[A-Za-z]+$/", text: line )
                                    let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
                                    let trimmedString = textLine.stringByTrimmingCharactersInSet(whitespaceSet)

                                    if trimmedString != "" {
                                        //                        print("Line \(line) is added")
                                        self.menuString.append(trimmedString)
                                    }
                                    //                    else {
                                    //                        print("Did not add line")
                                    //                        
                                    //                    }
                                    
                                    
                                    //let separated = split("Split Me!", {(c:Character)->Bool in return c==" "}, allowEmptySlices: false)
                                }
                            }
                            
                        }
                        else {
                            print("No Working ocrspace parsed text")
                        }
                    }
                }
            }catch {
                print("Error!")
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

    
    //    func callOCRSpace(img: UIImage) {
    //        let url = NSURL(string: "https://api.ocr.space/Parse/Image")!
    //        let request = NSMutableURLRequest(URL: url)
    ////        var data = "apikey=helloworld&isOverlayRequired=true&url=http://dl.a9t9.com/blog/ocr-online/screenshot.jpg&language=eng"
    //        var imageData: NSData = UIImageJPEGRepresentation(img, 0.6)!
    //
    ////        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding);
    //        request.HTTPMethod = "POST"
    //
    //        var boundary: String = "randomString"
    //        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    ////        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    ////        request.addValue("application/json", forHTTPHeaderField: "Accept")
    //        var session: NSURLSession = NSURLSession.sharedSession()
    //        var parametersDictionary: [NSObject : AnyObject] = ["helloworld": "apikey","True": "isOverlayRequired","eng": "language"]
    ////        var parametersDictionary: [NSObject : AnyObject] = ["apikey": "helloworld","isOverlayRequired": "True","language": "eng"]
    //
    //        // Create multipart form body
    //        var data1: NSData = self.createBodyWithBoundary(boundary, parameters: parametersDictionary, imageData: imageData)
    ////        var data1: String = "file=imageData&apikey=helloworld&isOverlayRequired=true&language=eng"
    //        request.HTTPBody = data1
    ////        request.HTTPBody = data1.dataUsingEncoding(NSUTF8StringEncoding)
    //
    //        do {
    //            var responseObject:NSURLResponse?
    //            var err:NSErrorPointer = NSErrorPointer()
    //            let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &responseObject)
    //            if let response1 = responseData as NSData?{
    //                if(err == nil) {
    //                    if let result = try NSJSONSerialization.JSONObjectWithData(response1, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
    //                        let parsedText: String = result["ParsedResults"]![0]!["ParsedText"]!! as! String
    //                        var parsedTextArr: [String] = []
    //
    //                        parsedText.enumerateLines { (line, stop) -> () in
    //                            parsedTextArr.append(line)
    //                        }
    //
    //                        print(parsedText)
    //                        print(parsedTextArr.count)
    //
    //                    }
    //                    else {
    //                        print("No Working ocrspace parsed text")
    //                    }
    //                }
    //            }
    //        }catch {
    //            print("Error!")
    //        }
    //
    //    }
    //
    //    func createBodyWithBoundary(boundary: String, parameters: [NSObject : AnyObject], imageData data: NSData) -> NSData {
    //
    //        var body: NSMutableData = NSMutableData()
    //
    //            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    ////            body.appendData("Content-Disposition: form-data; name=\"\("file")\"; filename=\"myfile.jpg\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    //            body.appendData("Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    //            body.appendData(data)
    //            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    //
    //
    //        for key in parameters.keys {
    //            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    //            body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    //            body.appendData("\(parameters["\(key)"])\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    //        }
    //        
    //        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    ////        let string1 = NSString(data: body, encoding: NSASCIIStringEncoding)
    ////        print(string1)
    //        return body
    //    }
    //    


}

//tesseract.charWhitelist = "01234567890";


