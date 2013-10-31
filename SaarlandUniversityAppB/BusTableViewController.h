//
//  BusTableViewController.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 20.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "WebViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface BusTableViewController : UITableViewController<CLLocationManagerDelegate>{
    NSMutableArray* busstations;
    IBOutlet CLLocationManager *locationManager;
    NSArray* sectionTitles;

}

#define BusID 5

@property (nonatomic) Database* database;



@end
