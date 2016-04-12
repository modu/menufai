//
//  LocalCache.swift
//  menufai
//
//  Created by Varun Vyas on 12/04/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//

import Foundation

class LocalCache{
    static let sharedInstance = LocalCache()
    private
    init(){
        cache = [:]
    }
    var cache: [String : String]
    static var count = 0
    public
    func getCache() -> [String:String] {
        return cache
    }
    
    func putCache(_cache: [String:String]){
        cache = _cache
    }
    
    func getUrl(menuString:String) -> String {
        if let url = cache[menuString]{
            return url
        }
        else {
            return ""
        }
    }
    
    func putUrl(menuString  :String , url :String) {
        cache[menuString] = url
    }
    
    func isPresent(menuString:String) -> Bool {
        if let url = cache[menuString] {
            return true;
        }
        else {
            return false;
        }
    }
    
    
    
}