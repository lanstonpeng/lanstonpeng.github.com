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
            fileManager.copyItemAtPath(recordBundlePath, toPath: recordDocumentPath, error: nil)
        }
        else
        {
            println("file exists")
        }
    }
    class func getPlistDirectory() -> NSString
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordPath = documentsPath.stringByAppendingPathComponent("record.plist")
        return recordPath
    }
    
    class func addRecord(cell:RecordCell) -> Bool
    {
        let recordPath = DataManipulator.getPlistDirectory()
        var recordArr = NSMutableArray(contentsOfFile:recordPath)
        
        var dic = NSMutableDictionary()
        dic.setObject(NSDate(), forKey: "startTime")
        dic.setObject(1, forKey: "recordType")
        dic.setObject(cell.duration, forKey: "duration")
        
        recordArr.insertObject(dic, atIndex: 0)
        recordArr.writeToFile(recordPath, atomically: true)
        return true
    }
    
    class func getAllRecords() -> NSArray
    {
        let recordPath = DataManipulator.getPlistDirectory()
        println(recordPath)
        return NSArray(contentsOfFile: recordPath)
    }
    
    
    
}
