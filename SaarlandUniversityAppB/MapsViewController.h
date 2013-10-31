//
//  MapsViewController.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 16.05.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotations.h"
#import "MapBackgroundViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CategorieTableViewController.h"
#import "DetailedPOIListViewController.h"
#import "WebViewController.h"
#import "UIRightPinAccessoryButton.h"
#import "UILeftPinAccessoryButton.h"
#import "LocationManagmentController.h"
#import "Reachability.h"
#import "JSONKit.h"
#import "Database.h"
#import "PartialSearchCell.h"
#import "SearchHistoryCell.h"


@class MapBackgroundViewController;

@interface MapsViewController : UIViewController<MKMapViewDelegate, UISearchBarDelegate, BackgroundMapToMap ,pinCategorieToMap, detailedTableToMap, LocationManagmentControllerDelegate,UITableViewDataSource,UITableViewDelegate >{
    
    @private
    IBOutlet MKMapView *map;
    IBOutlet UISearchBar *searchBar;
    LocationManagmentController * locationManagmentController;
    NSMutableData* responseRouteData;
    NSMutableArray* route;
    CLLocationCoordinate2D routeDestination;
    MKMapRect visibleStartRect;
    NSString* googleRouteLink;
    NSOperationQueue* backgroundThread;
    BOOL displayRoute;
    UIBarButtonItem* listBarButton;
    UIBarButtonItem* cancelBarButton;
    //contains PointOfInterest objects 
    NSArray* partialSearchArr;
    //contains NSStrings
    NSMutableArray* searchHistoryArr;
            
}


@property (nonatomic, strong) IBOutlet MKMapView *map;
@property (nonatomic, retain) IBOutlet  UISearchBar *searchBar;
@property (nonatomic) NSMutableData* responseRouteData;
@property (nonatomic) NSMutableArray* route;
@property (nonatomic) CLLocationCoordinate2D routeDestination;
@property (nonatomic) MKMapRect visibleStartRect;
@property     NSOperationQueue* backgroundThread;
@property (nonatomic) MKMapItem* appleMapsDestItem;
@property (nonatomic) Database* database;
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *showPositionButton;
@property (weak, nonatomic) IBOutlet UIButton *showMapBackgroundButton;



- (IBAction)showPositionPressed:(id)sender;
- (void)pinCategorieWithKey:(NSString *)categorie;
- (void)updateRoute;
- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;
- (void)rightAccessoryButtonTapped:(UIRightPinAccessoryButton *) sender;
- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar;
- (MKMapType)getCurrentMapType;
- (void)removeAllPins;
- (void)removeRouteFromMap;
-(void)pinPOIsThatIncludeSearchKey:(NSString *)key;



@end
