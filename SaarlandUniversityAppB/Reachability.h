
//
//  Reachability.h
//  SaarlandUniversityTest
//
//  Created by Tom Michels on 30.05.12.
//  Copyright (c) 2012 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} NetworkStatus;
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"



@interface Reachability : NSObject{
    BOOL localWiFiRef;
	SCNetworkReachabilityRef reachabilityRef;
}

//public methods to call, to check internet connection and website availability
+(BOOL)hasInternetConnection ;
+(BOOL)websiteAvailable:(NSString *)website;

@end
