//
//  MapBackgroundViewController.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapBackgroundViewController.h"
#import "MapsViewController.h"

@interface MapBackgroundViewController ()

@end

@implementation MapBackgroundViewController
@synthesize segmentedControl, mapType, delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    //if iOS 6 or higher
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        [self.removeRouteButton removeFromSuperview];
    }
        
    if([self.delegate respondsToSelector:@selector(getCurrentMapType)]){
      self.segmentedControl.selectedSegmentIndex = [self.delegate getCurrentMapType];
    }
    
    
    
}

- (void)viewDidUnload
{

    delegate = nil;
    [self setSegmentedControl:nil];
    [self setRemoveRouteButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)segmentedControllChanged:(id)sender {

    if (self.segmentedControl.selectedSegmentIndex == 0) {
        mapType = MKMapTypeStandard;
    }else if (self.segmentedControl.selectedSegmentIndex == 1) {
        mapType = MKMapTypeSatellite;
    } else if (self.segmentedControl.selectedSegmentIndex == 2) {
        mapType = MKMapTypeHybrid;
    }
    
    //Is anyone listening
    if([self.delegate respondsToSelector:@selector(segmentedControllChangedMapType:)]){
        [self.delegate segmentedControllChangedMapType:mapType];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (IBAction)removeAllPinsPressed:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(removeAllPins)]){
        [self.delegate removeAllPins];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)removeRoute:(id)sender {
    if([self.delegate respondsToSelector:@selector(removeRouteFromMap)]){
        [self.delegate removeRouteFromMap];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [self setDelegate:nil];
}




@end
