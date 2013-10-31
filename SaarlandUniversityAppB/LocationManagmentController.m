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


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.delegate locationError:error];
}



@end
