//
//  Annotations.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 16.05.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PointOfInterest.h"



@interface Annotations : NSObject <MKAnnotation>{
@private
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    BOOL canShowLeftCalloutButton;
    BOOL canShowRightCalloutButton;
    NSString * website;
    MKPinAnnotationColor pinColor;    
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * subtitle;

@property (nonatomic)  BOOL canShowLeftCalloutButton;

@property (nonatomic)  BOOL canShowRightCalloutButton;

@property (nonatomic, assign) MKPinAnnotationColor pinColor;

@property (nonatomic ,copy)  NSString * website;

-(void)setAnnotPropertiesWithPOI:(PointOfInterest *) poi;

@end
