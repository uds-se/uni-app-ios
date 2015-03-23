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

@synthesize selectedCampus;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];

    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    busstations = [NSMutableArray new];
    self.database = [Database new];
    
    [self updateModel];
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self updateView];
}


//update the model/data from database
-(void)updateModel{
    [self.database openDb];
    NSMutableArray* tempBusstations;
    tempBusstations = [self.database getPointsOfInterestForCategorieWithIDAndCampus:BusID campus:self.selectedCampus];
    NSLog(@"%@",self.selectedCampus);
    
    
    NSLog(@"Array size : %d ",[tempBusstations count]);
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
    if([self.selectedCampus isEqualToString:@"saar"]){
        
        busstations = ((NSArray*)[NSArray arrayWithObjects:busstationsArr, dudweilerBusstationArr, [NSArray arrayWithObjects:NSLocalizedString(@"Search a bus",nil), nil],nil]).mutableCopy;
        sectionTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Busstations Saarbücken",nil),NSLocalizedString(@"Busstations Dudweiler",nil),NSLocalizedString(@"Search",nil), nil];
    }
    else{
        busstations = ((NSArray*)[NSArray arrayWithObjects:busstationsArr, [NSArray arrayWithObjects:NSLocalizedString(@"Search a bus",nil), nil],nil]).mutableCopy;
        sectionTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Busstations Homburg",nil),NSLocalizedString(@"Search",nil), nil];
        
    }
    [self updateView];
}

-(void)updateView{
    [self.tableView reloadData];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
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
    categoryLabel.textAlignment = UITextAlignmentLeft;
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
    if (self.tableView.indexPathForSelectedRow.section==2) {
        wVC.urlAsString = @"http://mobile.bahn.de/bin/mobil/query.exe/dox?country=DEU&rt=1&use_realtime_filter=1&webview=&searchMode=ADVANCED";
    }else{
        if(self.tableView.indexPathForSelectedRow.section == 0){
            wVC.urlAsString = ((PointOfInterest*)[[busstations objectAtIndex:0]objectAtIndex: self.tableView.indexPathForSelectedRow.row]).website ;
        }
        else{
            wVC.urlAsString = ((PointOfInterest*)[[busstations objectAtIndex:1]objectAtIndex: self.tableView.indexPathForSelectedRow.row]).website ;
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}

@end
