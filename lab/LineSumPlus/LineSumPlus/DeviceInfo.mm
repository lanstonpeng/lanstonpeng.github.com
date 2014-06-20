//
//  DeviceInfo.mm
//  BaiduMaps
//
//  Created by liuzhengui on 11-1-21.
//  Copyright 2011 baidu. All rights reserved.
//

#import "DeviceInfo.h"
#import <sys/utsname.h>
#import <sys/types.h>
#import <sys/sysctl.h>

enum 
{
	MODEL_UNKNOWN = 1,
	MODEL_IPHONE_SIMULATOR,
	MODEL_IPOD_TOUCH,
	MODEL_IPOD_TOUCH_2G,
	MODEL_IPOD_TOUCH_3G,
	MODEL_IPOD_TOUCH_4G,
	MODEL_IPHONE,
	MODEL_IPHONE_3G,
	MODEL_IPHONE_3GS,
	MODEL_IPHONE_4G,
    MODEL_IPHONE_4G_REV_A, //3,2
    MODEL_IPHONE_4G_CDMA,  //3,3
    MODEL_IPHONE_4GS,      //4,1
    MODEL_IPHONE_5G_A1428, //5,1
    MODEL_IPHONE_5G_A1429, //5,2
	MODEL_IPAD
};

@interface DeviceInfo(InternalMethod)
@end

@implementation DeviceInfo

+ (BOOL) isIPodTouch
{
	int model = [DeviceInfo detectDevice];

	if (model == MODEL_IPOD_TOUCH || model == MODEL_IPAD)
	{
		return YES;
	}
	else 
	{
		return NO;
	}
	
}

+ (BOOL) isOS4
{
	BOOL bIOS4 = FALSE;
	
	NSString *platform = [DeviceInfo platform];
	NSRange rangeIPod = [platform rangeOfString:@"iPod4,"];
	if (NSNotFound != rangeIPod.location) 
	{
		bIOS4 = TRUE;
	}
	
	NSRange rangeIPhone = [platform rangeOfString:@"iPhone4,"];
	if (NSNotFound != rangeIPhone.location) 
	{
		bIOS4 = TRUE;
	}
	
	return bIOS4;
}

+ (BOOL)isOS7
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL) isStatusBarHotPoint
{
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    return (statusBarHeight >= 40.0f);
}

+ (BOOL) isEmulator
{
	if (MODEL_IPHONE_SIMULATOR == [DeviceInfo detectModel])
	{
		return TRUE;
	}
	
	
	return FALSE;
}

+ (NSString *)platform
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = (char*)malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithUTF8String:machine];
	free(machine);
	
	return platform;
}

+ (int) detectModel
{
	NSString *platform = [DeviceInfo platform];

	if ([platform isEqualToString:@"iPhone1,1"])
		return MODEL_IPHONE;

	if ([platform isEqualToString:@"iPhone1,2"])
		return MODEL_IPHONE_3G;

	if ([platform isEqualToString:@"iPhone2,1"])
		return MODEL_IPHONE_3GS;

	if ([platform isEqualToString:@"iPhone3,1"])
		return MODEL_IPHONE_4G;
    
    if ([platform isEqualToString:@"iPhone3,2"])
		return MODEL_IPHONE_4G_REV_A;
    
    if ([platform isEqualToString:@"iPhone3,3"])
		return MODEL_IPHONE_4G_CDMA;
    
    if ([platform isEqualToString:@"iPhone4,1"])
		return MODEL_IPHONE_4GS;
    
    if ([platform isEqualToString:@"iPhone5,1"])
		return MODEL_IPHONE_5G_A1428;
    
    if ([platform isEqualToString:@"iPhone5,2"])
		return MODEL_IPHONE_5G_A1429;

	if ([platform isEqualToString:@"iPod1,1"])
		return MODEL_IPOD_TOUCH;

	if ([platform isEqualToString:@"iPod2,1"])
		return MODEL_IPOD_TOUCH_2G;

	if ([platform isEqualToString:@"iPod3,1"])
		return MODEL_IPOD_TOUCH_3G;

	if ([platform isEqualToString:@"iPod4,1"])
		return MODEL_IPOD_TOUCH_4G;

	if ([platform isEqualToString:@"iPad1,1"])
		return MODEL_IPAD;

	if ([platform isEqualToString:@"i386"])
		return MODEL_IPHONE_SIMULATOR;
    
    if ([platform isEqualToString:@"x86_64"])
		return MODEL_IPHONE_SIMULATOR;

	return MODEL_UNKNOWN;
}


+ (uint) detectDevice 
{
	NSString *model= [[UIDevice currentDevice] model];

	// Some iPod Touch return "iPod Touch", others just "iPod"
	NSString *iPodTouch = @"iPod Touch";
	NSString *iPodTouchLowerCase = @"iPod touch";
	NSString *iPodTouchShort = @"iPod";
	NSString *iPad = @"iPad";

	NSString *iPhoneSimulator = @"iPhone Simulator";

	uint detected = MODEL_UNKNOWN;

	if ([model compare:iPhoneSimulator] == NSOrderedSame) 
	{
		// iPhone simulator
		detected = MODEL_IPHONE_SIMULATOR;
	}
	else if ([model compare:iPad] == NSOrderedSame) 
	{
		// iPad
		detected = MODEL_IPAD;
	} 
	else if ([model compare:iPodTouch] == NSOrderedSame) 
	{
		// iPod Touch
		detected = MODEL_IPOD_TOUCH;
	} 
	else if ([model compare:iPodTouchLowerCase] == NSOrderedSame) 
	{
		// iPod Touch
		detected = MODEL_IPOD_TOUCH;
	} 
	else if ([model compare:iPodTouchShort] == NSOrderedSame) 
	{
		// iPod Touch
		detected = MODEL_IPOD_TOUCH;
	} 
	else 
	{
		// Could be an iPhone V1 or iPhone 3G (model should be "iPhone")
		struct utsname u;
			
		// u.machine could be "i386" for the simulator, "iPod1,1" on iPod Touch, "iPhone1,1" on iPhone V1 & "iPhone1,2" on iPhone3G
		uname(&u);
			
		if (!strcmp(u.machine, "iPhone1,1")) 
		{
			detected = MODEL_IPHONE;
		} 
		else if (!strcmp(u.machine, "iPhone1,2"))
		{
			detected = MODEL_IPHONE_3G;
		} 
		else if (!strcmp(u.machine, "iPhone2,1"))
		{
			detected = MODEL_IPHONE_3GS;
		} 
		else if (!strcmp(u.machine, "iPhone3,1"))
		{
			detected = MODEL_IPHONE_4G;
		}
        else if (!strcmp(u.machine, "iPhone3,1"))
		{
			detected = MODEL_IPHONE_4G;
		}
        else if (!strcmp(u.machine, "iPhone3,2"))
		{
			detected = MODEL_IPHONE_4G_REV_A;
		}
        else if (!strcmp(u.machine, "iPhone3,3"))
		{
			detected = MODEL_IPHONE_4G_CDMA;
		}
        else if (!strcmp(u.machine, "iPhone4,1"))
		{
			detected = MODEL_IPHONE_4GS;
		}
        else if (!strcmp(u.machine, "iPhone5,1"))
		{
			detected = MODEL_IPHONE_5G_A1428;
		}
        else if (!strcmp(u.machine, "iPhone5,2"))
		{
			detected = MODEL_IPHONE_5G_A1429;
		}
	}

	return detected;
}

+ (NSString *) returnDeviceName:(BOOL)ignoreSimulator 
{
	NSString *returnValue = @"Unknown";

	switch ([DeviceInfo detectDevice])
	{
		case MODEL_IPHONE_SIMULATOR:
			 if (ignoreSimulator) 
			 {
				 returnValue = @"iPhone 4G";
			 } else 
			 {
				returnValue = @"iPhone Simulator";
			 }
			 break;
			
		case MODEL_IPOD_TOUCH:
			 returnValue = @"iPod Touch";
			 break;
		
		case MODEL_IPHONE:
			 returnValue = @"iPhone";
			 break;
			
		case MODEL_IPHONE_3G:
			 returnValue = @"iPhone 3G";
			 break;
            
        case MODEL_IPHONE_3GS:
            returnValue = @"iPhone 3GS";
            break;
            
        case MODEL_IPHONE_4G:
            returnValue = @"iPhone 4G";
            break;
            
        case MODEL_IPHONE_4G_REV_A:
            returnValue = @"iPhone 4G Rev A";
            break;
            
        case MODEL_IPHONE_4G_CDMA:
            returnValue = @"iPhone 4G CDMA";
            break;
            
        case MODEL_IPHONE_4GS:
            returnValue = @"iPhone 4GS";
            break;
            
        case MODEL_IPHONE_5G_A1428:
            returnValue = @"iPhone 5G A1428";
            break;
            
        case MODEL_IPHONE_5G_A1429:
            returnValue = @"iPhone 5G A1429";
            break;
        case MODEL_IPAD:
            returnValue = @"";
        
		default:
			 break;
	}

	return returnValue;
}

//add by chenjing
+ (NSString *)platformString{
    
    NSString *platform = [DeviceInfo platform];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

+ (bool)isRetinaScreen
{
    return ([UIScreen instancesRespondToSelector:@selector(scale)]?(2 == [[UIScreen mainScreen] scale]):NO);
    
}

+ (NSString*) getSystemVersion
{
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSString* strVer = [NSString stringWithFormat:@"%f",ver];
    return strVer;
}

+ (CGSize)getScreenSize
{
    CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
    return screenSize;
}


+(CGSize)getApplicationSize
{
    CGSize appSize = [UIScreen mainScreen].applicationFrame.size;
    return appSize;
}

+ (NSString*) getChannelID
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* channelFilePath = [NSString stringWithFormat:@"%@/channel",[mainBundle bundlePath]] ;//[mainBundle bundlePath];
    NSError* error = nil;
    
    NSString *strChannelID = [NSString stringWithContentsOfFile:channelFilePath encoding:NSUTF8StringEncoding error:&error]; 
    if (strChannelID == nil || [strChannelID length] <= 0)
    {
        strChannelID = @"faild";
    }
    else
    {
        strChannelID = [strChannelID stringByReplacingOccurrencesOfString: @"\r" withString:@""];
        strChannelID = [strChannelID stringByReplacingOccurrencesOfString: @"\n" withString:@""];    
    }

    return strChannelID;
}


+ (NSInteger) getSystemTime
{
    NSDate * senddate=[NSDate date];
    //获得系统日期
    NSCalendar * cal            = [NSCalendar currentCalendar];
    NSUInteger unitFlags        =  NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year  = [conponent year];
    NSInteger month = [conponent month];
    NSInteger day   = [conponent day];
    //NSString * nsDateString= [NSString stringWithFormat:@"%4d/%2d/%2d",year,month,day];
    
    NSInteger systemTime = year * 10000 + month * 100 + day;
//    NSString *nsDateString ;
//    
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"YYYY/MM/dd"];
//    nsDateString = [format stringFromDate:senddate];
//    [format release];

    return systemTime;
}


+ (NSString*) getSystemTimeStamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%f", a];
}

+(NSString*)getSoftVersion
{

   return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];


}


+(NSString*)getHomePath
{
    return NSHomeDirectory();
}

+(NSString*)getDocumentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   return [paths objectAtIndex:0];
}

+(NSString*)getCachePath
{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return  [paths objectAtIndex:0];
}

+(NSString*)getTmpPath
{
    return NSTemporaryDirectory();

}

@end
