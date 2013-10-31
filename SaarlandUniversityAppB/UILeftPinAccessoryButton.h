//
//  UILeftPinAccessoryButton.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 17.06.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface UILeftPinAccessoryButton : UIButton{
    CLLocationCoordinate2D coord;
}

@property CLLocationCoordinate2D coord;
@property NSString* title;
@property NSString* description;

@end
