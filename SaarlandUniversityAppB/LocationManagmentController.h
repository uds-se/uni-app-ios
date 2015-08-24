//
//  LocationManagmentController.h
//  SaarlandUniversity
//
//  Created by Tom Michels on 17.06.12.
//  Copyright (c) 2012 2012 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagmentControllerDelegate 
@required
- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;
@end


@interface LocationManagmentController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
    __weak id delegate;
}

@property (nonatomic,retain) CLLocationManager *locationManager;  
@property (nonatomic,weak) id  delegate;



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

@end
