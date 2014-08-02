//
//  MotionManager.swift
//  Focord2
//
//  Created by Lanston Peng on 8/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit
import CoreMotion

class MotionManager: NSObject {
    
    var motionManager:CMMotionManager
    init()
    {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.3
    }
    func startListen()
    {
        let updateQueue:NSOperationQueue = NSOperationQueue()
        updateQueue.name = "update motion"
        
        motionManager.startAccelerometerUpdatesToQueue(updateQueue, withHandler: { (accelerometerData:CMAccelerometerData!,error:NSError!) ->  Void in
        let accelData:CMAccelerometerData = self.motionManager.accelerometerData
        println(accelData.acceleration.z)
            })
    }
}
