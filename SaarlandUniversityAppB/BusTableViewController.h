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

@interface BusTableViewController : UIViewController<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray* busstations;
    IBOutlet CLLocationManager *locationManager;
    NSArray* sectionTitles;

}

#define BusID 5
@property (nonatomic) NSString* selectedCampus;
@property (nonatomic) Database* database;
//@property (nonatomic) UITableView* tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *searchBusTitle;
@property (weak, nonatomic) IBOutlet UITableViewCell *searchBusClick;
- (IBAction)searchBusClicked:(id)sender;



@end
