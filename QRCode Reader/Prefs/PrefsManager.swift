//
//  PrefsManager.swift
//  CIUWApp
//
//  Created by XianHuang on 5/12/20.
//  Copyright © 2020 ciuw. All rights reserved.
//

import Foundation

class PrefsManager:NSObject{
    
    class func set(key:String,value:Bool){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func get(key:String) -> Bool{
        let value = UserDefaults.standard.bool(forKey: key)
        return value
    }
    
    class func setString(key:String,value:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getString(key:String) -> String{
        let value = UserDefaults.standard.string(forKey: key) ?? ""
        return value
    }
    
    class func setInt(key:String,value:Int){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getInt(key:String) -> Int{
        let value = UserDefaults.standard.integer(forKey: key)
        return value
    }
    
    
    class func setFCMToken(val : String)
    {
        setString(key: "fcmToken", value: val)
    }
    
    class func  getFCMToken() -> String
    {
        return getString(key: "fcmToken")
    }
    
    class func setUserID(val : String)
    {
        setString(key: "userid", value: val)
    }
    
    class func  getUserID() -> String
    {
        return getString(key: "userid")
    }
    
    
    class func setEmail(val : String)
    {
        setString(key: "email", value: val)
    }
    
    class func  getEmail() -> String
    {
        return getString(key: "email")
    }
    
    class func setAvatar(val : String)
    {
        setString(key: "avatar", value: val)
    }
    
    class func  getAvatar() -> String
    {
        return getString(key: "avatar")
    }
    
    class func setFirstOpen(val: Int)
    {
        setInt(key: "firstopen", value: val)
    }
    
    class func getFirstOpen() -> Int
    {
        return getInt(key: "firstopen")
    }
    
    class func setVibrate(val : Int)
    {
        setInt(key: "vibrate", value: val)
    }
    
    class func  getVibrate() -> Int
    {
        return getInt(key: "vibrate")
    }

    class func setBeep(val : Int)
    {
        setInt(key: "beep", value: val)
    }
    
    class func  getBeep() -> Int
    {
        return getInt(key: "beep")
    }

    class func setHistory(val : Int)
    {
        setInt(key: "history", value: val)
    }
    
    class func  getHistory() -> Int
    {
        return getInt(key: "history")
    }

    

}
