//
//  LocationManagmentController.m
//  SaarlandUniversity
//
//  Created by Tom Michels on 17.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationManagmentController.h"

@implementation LocationManagmentController

@synthesize locationManager,delegate;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self; // send loc updates to myself
        [locationManager setDistanceFilter:kCLLocationAccuracyNearestTenMeters];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        // Check for iOS 8
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];

    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self.delegate locationUpdate:newLocation];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.delegate locationUpdate:[locations lastObject]];
    //NSLog(@"MAP LOC: %@", [locations lastObject]);
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User denied access to location");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            //NSLog(@" User allowed when in USE");
            [locationManager startUpdatingLocation];
        } break;
        case kCLAuthorizationStatusAuthorizedAlways:
        default:
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.delegate locationError:error];
}



@end
