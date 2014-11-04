//
//  DataManipulator.swift
//  Focord2
//
//  Created by Lanston Peng on 8/7/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class DataManipulator: NSObject {
  
    
    func placeCellOnBoard(cell:RecordCell)
    {
        
    }
   
    class func initFile()
    {
        let recordBundlePath = NSBundle.mainBundle().pathForResource("record", ofType: "plist")
        let recordDocumentPath = DataManipulator.getPlistDirectory()
        let fileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(recordDocumentPath)
        {
            fileManager.copyItemAtPath(recordBundlePath!, toPath: recordDocumentPath, error: nil)
        }
        else
        {
            println("file exists")
        }
    }
    class func getTodayStringID() -> NSString
    {
        let dateFormater = NSDateFormatter()
        
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        return dateFormater.stringFromDate(NSDate())
    }
    class func getCurrentTimeString() -> NSString
    {
        let dateFormater = NSDateFormatter()
        
        dateFormater.dateFormat = "HH:mm:ss"
        
        return dateFormater.stringFromDate(NSDate())
    }
    
    class func getPlistDirectory() -> NSString
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordPath = documentsPath.stringByAppendingPathComponent("record.plist")
        return recordPath
    }
    
    class func deleteRecord()
    {
    }
    class func addRecord(cell:RecordCell)
    {
        let recordPath = DataManipulator.getPlistDirectory()
        var todayDic = DataManipulator.getTodayAllRecords()
        
        func addOneRecord(cell:RecordCell,todayDictionary:NSMutableDictionary)
        {
            var dic = NSMutableDictionary()
            dic.setObject(DataManipulator.getCurrentTimeString(), forKey: "startTime")
            dic.setObject(1, forKey: "recordType")
            dic.setObject(cell.duration, forKey: "duration")
            todayDictionary.setObject(dic, forKey: dic.objectForKey("startTime") as NSString)
        }
        
        if let td = todayDic
        {
            //add a new record
            addOneRecord(cell, td)
        }
        else
        {
            //add today item
            var allRecordDic = NSMutableDictionary(contentsOfFile:recordPath)
            let todayDic = NSMutableDictionary()
            //allRecordDic.setObject(todayDic, forKey: DataManipulator.getTodayStringID())
            //add a new record
            addOneRecord(cell, todayDic)
        }
    }
    
    class func getAllRecords() -> NSMutableDictionary
    {
        let recordPath = DataManipulator.getPlistDirectory()
        println(recordPath)
        return NSMutableDictionary(contentsOfFile: recordPath)
    }
    
    class func getTodayAllRecords() -> NSMutableDictionary?
    {
        let allRecord = DataManipulator.getAllRecords()
        
        let todayString = DataManipulator.getTodayStringID()
        
        if (allRecord.objectForKey(todayString) != nil)
        {
            return allRecord.objectForKey(todayString) as? NSMutableDictionary
        }
        else
        {
            return nil
        }
    }
    
    
    
}
