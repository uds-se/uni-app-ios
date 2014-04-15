
//
//  MapsViewController.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 16.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapsViewController.h"
#import "TileOverlay.h"
#import "TileOverlayView.h"


@interface MapsViewController ()

@end

@implementation MapsViewController



@synthesize map, searchBar, responseRouteData, route, routeDestination, visibleStartRect, backgroundThread,appleMapsDestItem;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    searchBar.tintColor = self.navigationController.navigationBar.tintColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    backgroundThread = [NSOperationQueue new];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    map.showsUserLocation = YES;
    map.zoomEnabled = YES;  // enable doubletap zoom
    map.scrollEnabled = YES;
    map.mapType = MKMapTypeStandard;
    [map setDelegate:self];


    route = [NSMutableArray new];
    routeDestination = kCLLocationCoordinate2DInvalid;
    displayRoute = NO;
    googleRouteLink = @"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=driving&sensor=false";
    
    
    locationManagmentController = [LocationManagmentController new];
    locationManagmentController.delegate = self;
    
    [searchBar setDelegate:self];
    listBarButton = self.navigationItem.rightBarButtonItem;
    cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    
    
    //contains PointOfInterest objects
    partialSearchArr = [NSArray new];
    //searchHistory contains NSStrings
    searchHistoryArr = [NSMutableArray new];
    [self loadSearchHistory];
    
    // Initialize the TileOverlay with tiles in the application's bundle's resource directory.
    // Any valid tiled image directory structure in there will do.
    NSString *tileDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"OverlayTiles"];
    TileOverlay *overlay = [[TileOverlay alloc] initWithTileDirectory:tileDirectory];
    if (overlay) {
        [map addOverlay:overlay];
    }
    
    
    // Initialize the TileOverlay with tiles in the application's bundle's resource directory.
    // Any valid tiled image directory structure in there will do.
    NSString *tileDirectorySport = [[[NSBundle mainBundle]  resourcePath] stringByAppendingPathComponent:@"OverlayTilesSport"];
    TileOverlay *overlaySport = [[TileOverlay alloc] initWithTileDirectory:tileDirectorySport];
    if (overlaySport) {
        [map addOverlay:overlaySport];
    }

    
    // zoom in by a factor of two from the rect that contains the bounds
    // because MapKit always backs up to get to an integral zoom level so
    // we need to go in one so that we don't end up backed out beyond the
    // range of the TileOverlay.
    MKMapRect visibleRect = [map mapRectThatFits:overlay.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width / 2;
    visibleRect.origin.y += visibleRect.size.height / 2;
    visibleStartRect = MKMapRectMake(visibleRect.origin.x+ visibleRect.size.width / 4, visibleRect.origin.y+ visibleRect.size.height / 4, visibleRect.size.width/2,  visibleRect.size.height/2);
    map.visibleMapRect = visibleRect;
    
    [self.tableView setHidden:YES];

    
    self.navigationController.title = @"";
    self.database = [Database new];
    
    //Saves the default frame, set by the Interfacebuilder (Storyboard).  Will be read at Searchbar didBeginEditing
    tableViewFrame = self.tableView.frame;

    
}



-(MKMapView *) map {
    if (! map) map = [[MKMapView alloc]init];
    return map;
}

- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        [map removeOverlay:overlay];
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineJoin = kCGLineJoinRound;
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        return polylineView;
    } else {
        TileOverlayView *view = [[TileOverlayView alloc] initWithOverlay:overlay];
        view.tileAlpha = 1.0;
        return view;
    }
}




-(void)pinCategorieWithKey:(NSString *)categorie{
    categorie = [categorie uppercaseString];
    categorie = [[Database class] changeFormatOfString:categorie];
}

-(void)pinCategorieWithID:(int)ID{
    [self pinPOIsInArray:[self.database getPointsOfInterestForCategorieWithID:ID]];
}


-(void)pinPOIsThatIncludeSearchKey:(NSString *)key{
    NSString* capKey = [key.copy capitalizedString];;
    key = [key uppercaseString];
    if (key.length>2) {
        key = [[Database class] changeFormatOfString:key];
        if([self pinPOIsInArray:[self.database getPointsOfInterestWhereOneOfSearchKeysMatchesKey:key]]){
            [searchHistoryArr removeObject:capKey];
            [searchHistoryArr insertObject:capKey atIndex:0];
        }
    }
    
}




-(BOOL)pinPOIsInArray:(NSArray *) POIs{
    BOOL res = false;
    if (POIs.count > 0) {
        for(PointOfInterest* poi in POIs){
            Annotations *annot = [Annotations new];
            [annot setAnnotPropertiesWithPOI:poi];
            [self.map addAnnotation:annot];
        }
        res = true;
    }
    [self setZoomRectAccorindToAnnots];
    return res;
    
}

-(void)pinPOIWithID:(int) ID{
    [self pinPOIsInArray:[self.database getPointsOfInterestForIDs:[NSArray arrayWithObject:[NSNumber numberWithInt:ID ]]]];
}

-(void)setZoomRectAccorindToAnnots{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in map.annotations)
    {
        if (annotation != map.userLocation  ) {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x-1500, annotationPoint.y-1500, 3000.0, 3000.0);
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    if (!MKMapRectIsNull(zoomRect)) {
        [map setVisibleMapRect:zoomRect animated:YES];
    }
}



- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{  
    MKPinAnnotationView *annView = nil;

    if (annotation != mapView.userLocation) {
        static NSString *MyAnnotationIdentifier = @"MyPin";
        annView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:MyAnnotationIdentifier];
        Annotations *annot;
        if (!annView){
             annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPin"];
        } else {
            annView.leftCalloutAccessoryView = nil;
            annView.rightCalloutAccessoryView = nil;
            annView.annotation = annotation;
        }
        
        if ([annotation isKindOfClass:[Annotations class]]){
            annot = (Annotations*)annotation ;
                
            //button to show route on Map
            if (annot.canShowLeftCalloutButton){
                UILeftPinAccessoryButton *calcRouteButton = [[UILeftPinAccessoryButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
                calcRouteButton.coord = annot.coordinate;
                calcRouteButton.title = annot.title;
                [calcRouteButton addTarget:self action:@selector(calcRouteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                annView.leftCalloutAccessoryView = calcRouteButton;
            } 
                

            //creates custom UIButton to attach annotation information to it
            if (annot.canShowRightCalloutButton && (annot.website.length > 0)) {
                UIRightPinAccessoryButton *rightAccessoryButton = [[UIRightPinAccessoryButton alloc] initWithFrame: CGRectMake(0, 0, 24, 24)];
                rightAccessoryButton.annotPin = annot;
                [rightAccessoryButton addTarget:self action:@selector(rightAccessoryButtonTapped:) forControlEvents: UIControlEventTouchUpInside];
                annView.rightCalloutAccessoryView = rightAccessoryButton;
            }
        }
            
        
        annView.canShowCallout = YES;
        annView.pinColor = annot.pinColor; 
        annView.animatesDrop=YES;  
        return annView;
    }
    else {
        [mapView.userLocation setTitle:@"Aktueller Standort"];
        return nil;
    }
    
}




- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
    searchBar = aSearchBar;
    NSString *pointOfInterest = searchBar.text;
    [self.tableView setHidden:YES];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [searchBar setShowsCancelButton:NO animated:YES];
    }else{
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    [self pinPOIsThatIncludeSearchKey:pointOfInterest];
    [self.navigationItem setRightBarButtonItem:listBarButton animated:YES];
    [searchBar resignFirstResponder];
}

- (void) keyboardWillShow:(NSNotification *)nsNotification {
    NSDictionary *userInfo = [nsNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - kbSize.height);
    });
    
}

- (void) keyboardWillDisappear:(NSNotification *)nsNotification {
    self.tableView.frame = self.view.frame;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar{
    [self.navigationItem setRightBarButtonItem:nil animated:NO];
    [map removeFromSuperview];
    
    // Set the frame of the tableView to the inital frame, calculated by the interface builder
    self.tableView.frame = tableViewFrame;
    [self.view addSubview:self.tableView];

    [self.navigationItem setRightBarButtonItem:cancelBarButton animated:YES];
    [self.tableView setHidden:NO];
    if (searchBar.text.length == 0) {
        partialSearchArr = nil;
        partialSearchArr = [NSMutableArray new];
    }
    [searchBar sizeToFit];
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length>0 && searchText.length < 50) {
        NSString* key = searchText.uppercaseString;
        key = [[Database class] changeFormatOfString:key];
        partialSearchArr = [self.database getPointsOfInterestPartialMatchedForSearchKey:key];
    }
    if (searchText.length == 0) {
        partialSearchArr = nil;
    }
    [self.tableView reloadData];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar{
    [self.tableView removeFromSuperview];
    [self.view addSubview:map];
    [map addSubview:self.showPositionButton];
    [map addSubview:self.showMapBackgroundButton];
    map.userInteractionEnabled = YES;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        [searchBar setShowsCancelButton:NO animated:YES];
//    }else{
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
//    }
    //[searchBar setShowsCancelButton:NO animated:YES];
    [self.tableView setHidden:YES];
    [self.navigationItem setRightBarButtonItem:listBarButton animated:YES];
    [searchBar sizeToFit];

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
    [searchBar resignFirstResponder];
}

-(void)cancelButtonPressed{
    [searchBar resignFirstResponder];
}




-(IBAction)showPositionPressed:(id)sender{
    [map setCenterCoordinate:map.userLocation.location.coordinate animated:YES];
}

- (void)segmentedControllChangedMapType: (MKMapType) type{
    map.mapType = type;
}

-(MKMapType)getCurrentMapType{
    return map.mapType;
}


-(void)removeAllPins{
    NSMutableArray *toRemove = [NSMutableArray new];
    for (id annotation in map.annotations)
        if (annotation != map.userLocation)
            [toRemove addObject:annotation];
    [map removeAnnotations:toRemove];
    routeDestination = kCLLocationCoordinate2DInvalid;
    displayRoute = NO;
    [self updateRoute];
}

-(void)removeRouteFromMap{
    routeDestination = kCLLocationCoordinate2DInvalid;
    displayRoute = NO;
    [self updateRoute];    
}


-(void)rightAccessoryButtonTapped:(UIRightPinAccessoryButton *) sender{
    if (([sender.annotPin.title isEqualToString:@"Mensa"] && [sender.annotPin.subtitle isEqualToString:@"Restaurant"]) ||
        [sender.annotPin.title isEqualToString:@"Mensacafé"]) {
        [self performSegueWithIdentifier:@"showMensaMenu" sender:sender];
    } else { 

        [self performSegueWithIdentifier:@"showRightAccessoryWebView" sender:sender];  
    }
   
}







/*
 *
 *
 * Route Part
 *
 */

-(void)calcRouteButtonTapped:(UILeftPinAccessoryButton *) sender{
    Class itemClass = [MKMapItem class];
    NSString* message;
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) ) {
        if ([[Reachability class] hasInternetConnection]) {
            UIAlertView *av = [UIAlertView new];
            [av addButtonWithTitle:@""];
            UIButton *walkButton = [av.subviews lastObject];
            [walkButton setTag:0];
            [walkButton setImage:[UIImage imageNamed:@"walkingIcon.png"] forState:UIControlStateNormal];
            
            [av addButtonWithTitle:@""];
            UIButton *carButton = [av.subviews lastObject];
            [carButton setTag:1];
            [carButton setImage:[UIImage imageNamed:@"carIcon.png"] forState:UIControlStateNormal];
            
            if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
                
                self.appleMapsDestItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:sender.coord addressDictionary:nil]];
                self.appleMapsDestItem.name = sender.title;
                
                [walkButton addTarget:self action:@selector(showRouteAppleMaps:) forControlEvents:UIControlEventTouchUpInside];
                [carButton addTarget:self action:@selector(showRouteAppleMaps:) forControlEvents:UIControlEventTouchUpInside];
                
                
                NSString *version = [[UIDevice currentDevice] systemVersion];
                BOOL isAtLeast7 = [version hasPrefix:@"7."];
                if (isAtLeast7) {
                    NSDictionary *launchOptions;
                    launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
                    // Get the "Current User Location" MKMapItem
                    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                    // Pass the current location and destination map items to the Maps app
                    // Set the direction mode in the launchOptions dictionary
                    [MKMapItem openMapsWithItems:@[currentLocationMapItem, appleMapsDestItem] launchOptions:launchOptions];
                }else{
                    [av show];
                }
                
                
                
            } else {
                if ([self isUserAroundCampus]) {
                    routeDestination = sender.coord;
                    [walkButton addTarget:self action:@selector(showGoogleRoute:) forControlEvents:UIControlEventTouchUpInside];
                    [carButton addTarget:self action:@selector(showGoogleRoute:) forControlEvents:UIControlEventTouchUpInside];
                    [av show];
                } else {
                    message = [NSString stringWithFormat:NSLocalizedString(@"Calculating a route is only available around campus",nil)];
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Route feature not available",nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [errorAlert show];
                }
                
            }
            
        } else {
            message = [NSString stringWithFormat:NSLocalizedString(@"Route couldn't be calculated. Please check your internet connection and try again",nil)];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No internet conncetion",nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
            routeDestination = kCLLocationCoordinate2DInvalid;
            [map removeOverlays:route];
        }
    }else {
        message = [NSString stringWithFormat:NSLocalizedString(@"Please enable the location services in your settings and authorize the Saarland University App to access them",nil)];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location services disabled",nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        routeDestination = kCLLocationCoordinate2DInvalid;
        [map removeOverlays:route];
    }
}


//Checks if User is within a certain area around campus.
-(BOOL)isUserAroundCampus{
    CLLocationCoordinate2D topLeftCoord = CLLocationCoordinate2DMake(49.28572341,6.98284149);
    CLLocationCoordinate2D bottomRightCoord = CLLocationCoordinate2DMake(49.22544538,7.06111908);
       
    if (topLeftCoord.latitude > map.userLocation.coordinate.latitude &&
        bottomRightCoord.latitude < map.userLocation.coordinate.latitude &&
        topLeftCoord.longitude < map.userLocation.coordinate.longitude &&
        bottomRightCoord.longitude > map.userLocation.coordinate.longitude) {
        return YES;
    }
    return NO;
}

/*
 * chooses Directionmode and then opens Apple Maps with user location as starting point and appleMapsDestItem as Destination
 */
- (void) showRouteAppleMaps:(UIButton *)sender{
    // Set the directions mode to "Walking"
    NSDictionary *launchOptions;
    if (sender.tag==0) {
        launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
    } else {
        launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    }
    // Get the "Current User Location" MKMapItem
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    // Pass the current location and destination map items to the Maps app
    // Set the direction mode in the launchOptions dictionary
    [MKMapItem openMapsWithItems:@[currentLocationMapItem, appleMapsDestItem] launchOptions:launchOptions];

}


-(void) showGoogleRoute:(UIButton *)sender{
    if (sender.tag==0) {
        googleRouteLink = @"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=walking&sensor=false";
    } else {
        googleRouteLink = @"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=drivinging&sensor=false";
    }
    
    @try {
        displayRoute = YES;
        [self updateRoute];
    }
    @catch (NSException *exception) {
        NSLog(@"updateRoute1 try failed");
    }
}



- (void) updateRoute{
    if (displayRoute && CLLocationCoordinate2DIsValid(routeDestination)) {
        if ([[Reachability class] hasInternetConnection]) {
            if ([CLLocationManager locationServicesEnabled] ) {
                if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
                    if ([self isUserAroundCampus]) {
                        [self calcRoute];
                    }else{
                        NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Calculating a route is only available around campus",nil)];
                        UIAlertView *aroundCampusAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Route feature not available",nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [aroundCampusAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                        [map removeOverlays:route];
                        routeDestination = kCLLocationCoordinate2DInvalid;
                        displayRoute = NO;
                    }
                } else {
                    NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Please authorize the Saarland University App to access your location services",nil)];
                    UIAlertView *locationAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Accessing location services not authorized",nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [locationAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                    //[locationAlert show];
                }
            } else {
                NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Please enable the location services in your settings",nil)];
                UIAlertView *locationAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location services disabled",nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [locationAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                [map removeOverlays:route];
                displayRoute = NO;
                routeDestination = kCLLocationCoordinate2DInvalid;
            }
        }else {
            NSLog(@"no connection, keep old route");
        }
    }else {
        [map removeOverlays:route];
        displayRoute = NO;
        //routeDestination = kCLLocationCoordinate2DInvalid;
    }
   
    
}



//gets called when user location is updated
- (void)locationUpdate:(CLLocation *)location{
    @try {
        [self updateRoute];
    }
    @catch (NSException *exception) {
        NSLog(@"updateRoute2 try failed");
    }
}

- (void)locationError:(NSError *)error{
    NSLog(@"%@",[error description]);
}


// do not call this method. call update route instead
- (void) calcRoute{
    CLLocationCoordinate2D from = map.userLocation.coordinate;
    CLLocationCoordinate2D to = routeDestination;
    
   // CLLocationCoordinate2D from  = CLLocationCoordinate2DMake(40.740234,-74.034848);
   // CLLocationCoordinate2D to = CLLocationCoordinate2DMake(40.744428,-74.030685);
    NSString* startStr =[NSString stringWithFormat:@"%f,%f", from.latitude,from.longitude];
    NSString* endStr =[NSString stringWithFormat:@"%f,%f", to.latitude, to.longitude];    
    NSURL *nsURL = [NSURL URLWithString:[NSString stringWithFormat:googleRouteLink, startStr, endStr]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:nsURL];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    responseRouteData = [NSMutableData new];
}


 -(void)connectionDidFinishLoading:(NSURLConnection *)connection{
     if (responseRouteData) {
         [map removeOverlays:route];
         [route removeAllObjects];
         NSMutableDictionary *data1 = [responseRouteData objectFromJSONData];
         
         NSMutableArray *ad = [data1 objectForKey:@"routes"];
         NSMutableArray *data2 = [[ad objectAtIndex:0] objectForKey:@"legs"];
         NSMutableArray *data3 = [[data2 objectAtIndex:0] objectForKey:@"steps"];
         
         MKPolyline *polyLine; 
         for(int i=0;i<[data3 count];i++){        
             NSString *str =[[[data3 objectAtIndex:i]objectForKey:@"polyline"]objectForKey:@"points"];
             polyLine =  [self polylineWithEncodedString: str];
             
             [route addObject:polyLine];
             [map addOverlay:polyLine]; 
         }
    }
    else {
        NSLog(@"Response data is empty: %@",responseRouteData);
    }
 } 
 
 

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.responseRouteData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseRouteData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.responseRouteData =nil;
}

// decodes the polyline from google api
- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}


/*
 *
 *History TableView Part
 *
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchBar.text.length>0) {
        return partialSearchArr.count;
    }else{
        return searchHistoryArr.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (searchBar.text.length>0) {
        return 47;
    }
    else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (searchBar.text.length>0) {
        static NSString *CellIdentifier = @"parCell";
        PartialSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        PointOfInterest* poi = ((PointOfInterest*)[partialSearchArr objectAtIndex:indexPath.row]);
        cell.titleLabel.text = poi.title;
        cell.deatailLabel.text = poi.subtitle;
        NSString* imageName = [@"cat" stringByAppendingString:[NSString stringWithFormat:@"%d.png",poi.categorieID]];
        cell.imageView.image = [UIImage imageNamed:imageName ];
        return cell;
        
    }else{
        static NSString *CellIdentifier = @"histCell";
        SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.titleLabel.text = [searchHistoryArr objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"searchHistIcon.png"];
        return cell;
    }
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchBar.text.length > 0) {
        id poi = [partialSearchArr objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        int ID;
        NSString* title;
        if ([poi isKindOfClass:[PointOfInterest class]]) {
            ID = ((PointOfInterest *)poi).ID;
            title = ((PointOfInterest *)poi).title;
            //small delay so that the pin will "fly in" when the map is och screen
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.08 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
                [self pinPOIWithID:ID];
            //});

            [searchHistoryArr removeObject:title];
            [searchHistoryArr insertObject: title atIndex:0];
            
        }
    }else{
        NSString* searchKey = ((NSString *)[searchHistoryArr objectAtIndex:self.tableView.indexPathForSelectedRow.row]).copy;
        [searchHistoryArr removeObject:searchKey];
        [searchHistoryArr insertObject: searchKey atIndex:0];
        //small delay so that the pin will "fly in" when the map is och screen
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.08 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
            [self pinPOIsThatIncludeSearchKey:searchKey];
        //});
    }
    
    [searchBar resignFirstResponder];
}






-(void) loadSearchHistory{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedArray = [currentDefaults objectForKey:@"savedSearchHistory"];
    if (savedArray != nil)
    {
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (oldArray != nil) {
            searchHistoryArr = [[NSMutableArray alloc] initWithArray:oldArray];
        } else {
            searchHistoryArr = [[NSMutableArray alloc] init];
        }
    }
}

-(void) saveSearchHistory {
    if (searchHistoryArr.count > 25) {
        searchHistoryArr = [searchHistoryArr subarrayWithRange:NSMakeRange(0, 24)].mutableCopy;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:searchHistoryArr] forKey:@"savedSearchHistory"];
}






-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"showMapBackground"]) {
        MapBackgroundViewController *myCtrl = segue.destinationViewController ;
        myCtrl.delegate = self;
    }
    
    if ([segue.identifier isEqualToString: @"showCategoriesList"]) {
        CategorieTableViewController *myCatViewCont = segue.destinationViewController;
        myCatViewCont.delegate = self;
        myCatViewCont.categoriesArr = [self.database getAllCategorieTitles];
        myCatViewCont.IDArr = [self.database getAllCategorieIDs];
    } 
    
    if ([segue.identifier isEqualToString: @"showRightAccessoryWebView"]) {
        WebViewController *webViewConroller = segue.destinationViewController ;
        UIRightPinAccessoryButton *senderButton = sender;
        [webViewConroller  setUrlAsString:[NSString stringWithString:senderButton.annotPin.website]];
        [webViewConroller setTitle:senderButton.annotPin.title];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [self saveSearchHistory];
    [searchBar resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    map = nil;
    searchBar = nil;
    route = nil;
    locationManagmentController = nil;
    responseRouteData = nil;
    route =nil;
    
    
    [self setTableView:nil];
    [self setShowPositionButton:nil];
    [self setShowMapBackgroundButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
