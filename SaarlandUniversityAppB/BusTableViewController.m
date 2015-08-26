//
//  BusTableViewController.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 20.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import "BusTableViewController.h"

@interface BusTableViewController ()

@end

@implementation BusTableViewController

@synthesize selectedCampus,tableview,searchBusTitle;

/*- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (CLLocation *)currentUserLocation {
    return locationManager.location;
}



- (void)viewDidLoad
{
    //adjust backroundimage if iPhone5
    NSString *filename= @"HomeScreenBackgroundiPhone.jpg";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if (screenRect.size.height == 568.0f)
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"-568@2x.jpg"];
        
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        filename = @"HomeScreenBackgroundiPad.jpg";
    }
    //self.view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
    searchBusTitle.backgroundColor = [UIColor clearColor];
	searchBusTitle.opaque = NO;
	searchBusTitle.font = [UIFont boldSystemFontOfSize:18];
    searchBusTitle.textColor = [UIColor colorWithRed:(17/255.f) green:(56/255.f) blue:(92/255.f) alpha:1];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
    [self.tableview setBackgroundView:bg];
    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    

    busstations = [NSMutableArray new];
    self.database = [Database new];
    
    [self updateModel];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self updateView];
    //NSLog(@"%@", [locations lastObject]);
}



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self updateView];
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
            //NSLog(@" User Allowed when in USE");
            [locationManager startUpdatingLocation];
        } break;
        case kCLAuthorizationStatusAuthorizedAlways:
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error occured while accessing the location");
}


//update the model/data from database
-(void)updateModel{
    [self.database openDb];
    NSMutableArray* tempBusstations;
    tempBusstations = [self.database getPointsOfInterestForCategorieWithIDAndCampus:BusID campus:self.selectedCampus];
   
    
    
    
    NSMutableArray* busstationsArr = [NSMutableArray new];
    NSMutableArray* dudweilerBusstationArr = [NSMutableArray new];
    [self.database closeDb];
    NSMutableArray* busstationtitles = [NSMutableArray new];
    for (PointOfInterest* busstation in tempBusstations) {
        if (![busstationtitles containsObject:busstation.title] ) {
            if([self.selectedCampus isEqualToString:@"saar"]){
                if([busstation.title isEqualToString:@"Bürgerhaus"] || [busstation.title isEqualToString:@"Dudweiler Markt"]){
                
                    [dudweilerBusstationArr addObject:busstation];
                }
                else{
                    [busstationsArr addObject:busstation];
                }
            }
            else{
                
                [busstationsArr addObject:busstation];
            }
            [busstationtitles addObject:busstation.title];
        }
    }
    NSString *localizedStr = NSLocalizedString(@"Busstations", nil);
    if([self.selectedCampus isEqualToString:@"saar"]){
        
        busstations = ((NSArray*)[NSArray arrayWithObjects:busstationsArr, dudweilerBusstationArr,nil]).mutableCopy;
        sectionTitles = [NSArray arrayWithObjects:[localizedStr stringByAppendingString:@" Saarbücken"], [localizedStr stringByAppendingString:@" Dudweiler"], nil];
    }
    else{

        
        busstations = ((NSArray*)[NSArray arrayWithObjects:busstationsArr,nil]).mutableCopy;
        sectionTitles = [NSArray arrayWithObjects:[localizedStr stringByAppendingString:@" Homburg"], nil];
        
    }
    [self updateView];
}

-(void)updateView{
    [self.tableview reloadData];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //self.tableView.frame = CGRectMake(0,200,320,504);
}

- (IBAction)searchBusClicked:(id)sender{
    [self performSegueWithIdentifier:@"searchBus" sender:self];

}




#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return busstations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ((NSArray*)[busstations objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int val=0;
    if([self.selectedCampus isEqualToString:@"saar"]){
        val=2;
    }
    else{
        val=1;
    }
    
    if (indexPath.section==val) {
        cell.textLabel.text = [[busstations objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        cell.detailTextLabel.text = @"Bahn.de";
    }else{
        
        PointOfInterest* poi = ((PointOfInterest*)[[busstations objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
        cell.textLabel.text = poi.title;
        
        cell.detailTextLabel.text = @"";
        
        CLLocation* busLoc =  [[CLLocation alloc] initWithLatitude:poi.latitude longitude:poi.longitude];
        
        float distanceInM = [busLoc distanceFromLocation:[self currentUserLocation]];
        //NSLog(@"DISTANCE :: %f", distanceInM);
        if (distanceInM > 1000) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f km", distanceInM/1000];
        } else {
            if (distanceInM > 25) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f m", distanceInM];
            } else {
                if (distanceInM > 0.001) {
                    cell.detailTextLabel.text = NSLocalizedString(@"At busstation",nil);
                } else {
                    cell.detailTextLabel.text = @"";
                }
            }
        }
    }
    
    [cell.textLabel setNumberOfLines:2];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.detailTextLabel setNumberOfLines:2];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    CGRect cg = [cell.textLabel frame];
    [cell.textLabel setFrame:CGRectMake(cg.origin.x, cg.origin.y-2, cg.size.width, cg.size.height+6)];
 

    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 50.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
	UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //color of the lable
	categoryLabel.backgroundColor = [UIColor clearColor];
	categoryLabel.opaque = NO;
	categoryLabel.font = [UIFont boldSystemFontOfSize:18];
    categoryLabel.textColor = [UIColor colorWithRed:(17/255.f) green:(56/255.f) blue:(92/255.f) alpha:1];
    //position of the lable
	categoryLabel.frame = CGRectMake(15.0, 15.0, categoryView.frame.size.width, 30.0);
    categoryLabel.textAlignment = NSTextAlignmentLeft;
    //set the lable text

    categoryLabel.text = [sectionTitles objectAtIndex:section];

    
	[categoryView addSubview:categoryLabel];
    categoryView.backgroundColor = [UIColor clearColor];
	return categoryView;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showBusWebview" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewController* wVC = segue.destinationViewController;
    
    
    if ([segue.identifier isEqualToString:@"searchBus"]) {
        
        
        wVC.urlAsString = @"http://mobile.bahn.de/bin/mobil/query.exe/dox?country=DEU&rt=1&use_realtime_filter=1&webview=&searchMode=ADVANCED";
        
    }else{
        if(self.tableview.indexPathForSelectedRow.section == 0){
            wVC.urlAsString = ((PointOfInterest*)[[busstations objectAtIndex:0]objectAtIndex: self.tableview.indexPathForSelectedRow.row]).website ;
        }
        else{
            wVC.urlAsString = ((PointOfInterest*)[[busstations objectAtIndex:1]objectAtIndex: self.tableview.indexPathForSelectedRow.row]).website ;
        }
        
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}

@end
