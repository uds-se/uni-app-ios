//
//  MapBackgroundViewController.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 18.05.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@protocol BackgroundMapToMap <NSObject>
@required
- (void)segmentedControllChangedMapType:(MKMapType) type ;
- (MKMapType) getCurrentMapType;
- (void) removeAllPins;
- (void) removeRouteFromMap;
@end


@interface MapBackgroundViewController : UIViewController{
    IBOutlet UISegmentedControl *segmentedControl;
    __weak id <BackgroundMapToMap> delegate;
    
}

@property (weak, nonatomic) IBOutlet UIButton *removeRouteButton;

@property IBOutlet UISegmentedControl *segmentedControl;
@property MKMapType mapType;
@property(nonatomic,weak)id  delegate;



- (IBAction)segmentedControllChanged:(id)sender;
- (IBAction)removeAllPinsPressed:(id)sender;
- (IBAction)removeRoute:(id)sender;

@end
