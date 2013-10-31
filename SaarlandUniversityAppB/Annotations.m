//
//  Annotations.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 16.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Annotations.h"

@implementation Annotations

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize pinColor;
@synthesize canShowLeftCalloutButton;
@synthesize canShowRightCalloutButton;
@synthesize website;

-(void)setAnnotPropertiesWithPOI:(PointOfInterest *) poi{
    if (poi.title.length >0) {
        self.title = poi.title;
    }
    self.subtitle = poi.subtitle;
    self.website = poi.website;
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(poi.latitude, poi.longitude);
    self.coordinate = loc;
    self.pinColor = poi.color;
    self.canShowLeftCalloutButton = poi.canShowLeftCallout;
    self.canShowRightCalloutButton = poi.canShowRightCallout;
}


@end
