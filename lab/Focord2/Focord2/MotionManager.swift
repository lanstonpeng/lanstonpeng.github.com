//
//  MotionManager.swift
//  Focord2
//
//  Created by Lanston Peng on 8/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit
import CoreMotion
import QuartzCore

public protocol MotionManagerDelegate
{
    func deviceDidFlipToBack()
    func deviceDidFlipToFront()
}

class MotionManager: NSObject {
    
    internal var boundView:UIView?
    var didFlipToBack:Bool
    var delegate:MotionManagerDelegate?
    var duration:CGFloat
    
    var motionManager:CMMotionManager
    override init()
    {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 1.0
        motionManager.deviceMotionUpdateInterval = 1.0 / 60
        self.didFlipToBack = false
        duration = 0.0;
    }
    func startListen()
    {
        let updateQueue:NSOperationQueue = NSOperationQueue()
        updateQueue.name = "update motion"
        
        motionManager.startAccelerometerUpdatesToQueue(updateQueue, withHandler: { (accelerometerData:CMAccelerometerData!,error:NSError!) ->  Void in
            let accelData:CMAccelerometerData = self.motionManager.accelerometerData
            if( abs(accelData.acceleration.z - 1) < 0.01 )
            {
                
                if self.didFlipToBack == false
                {
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        self.delegate!.deviceDidFlipToBack()
                    })
                }
                
                self.didFlipToBack = true
                self.duration += 1.0
                /*
                CGFloat angle =  atan2( motion.gravity.x, motion.gravity.y );
                CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
                self.horizon.transform = transform; 
                */
            }
            else
            {
                self.didFlipToBack = false
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    self.delegate!.deviceDidFlipToFront()
                })
            }
            
            })
        /*
        let deviceQueue:NSOperationQueue = NSOperationQueue()
        motionManager.startDeviceMotionUpdatesToQueue(deviceQueue, withHandler: {(motion:CMDeviceMotion! , error:NSError! ) -> Void in
            var transform = CATransform3DMakeRotation(CGFloat(motion.attitude.pitch), 1, 0, 0)
            
			transform = CATransform3DRotate(transform, CGFloat(motion.attitude.roll), 0, 1, 0)
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                self.boundView!.layer.transform = transform
                })
            })
        */
    }
    func stopListen()
    {
        duration = 0
        motionManager.stopAccelerometerUpdates()
    }
}
