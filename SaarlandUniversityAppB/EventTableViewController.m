//
//  EventTableViewController.m
//  SaarlandUniversityAppB
//
//  Created by Matthias Sambale on 26.06.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "EventTableViewController.h"
#import "EventItemCell.h"

@interface EventTableViewController ()

@end

@implementation EventTableViewController

@synthesize selectedItem, events,eventItems,priorityQueueEvents;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//runs in background thread
- (void)RSSFeedParserDidEndDocument {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    NSArray* reversedArray = [[rssFeed.feedItems.copy reverseObjectEnumerator] allObjects];

    eventItems = reversedArray.mutableCopy;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

    [self performSelectorOnMainThread:@selector(endRefresh) withObject:nil waitUntilDone:NO];

    if (eventItems.count > 0) {
        [self saveEventsToFile];
    }
    [self parseAllEventsWithOperation];

    NSLog(@"RssFeed parsing ended");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    priorityQueueEvents = [NSOperationQueue new];
    
    events = [[NSMutableDictionary alloc] init];
    
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor colorWithRed:7/255.0f green:49/255.0f blue:92/255.0f alpha:1.0f];
    refreshControl.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    refreshControl.activityIndicatorViewColor = [UIColor colorWithRed:17/255.0f green:56/255.0f blue:92/255.0f alpha:1.0f];

    
    
    
    [self loadSavedData];
    
    if ([Reachability hasInternetConnection]) {
        [self refreshData];
        [refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, -45) animated:YES];
    }else {
        if (eventItems.count<= 0) {
            UIAlertView *internetErrorAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"No internet conncetion", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"Events couldn´t be loaded. Please check your internet connection and try again", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [internetErrorAlert show];
            [refreshControl endRefreshing];
        }
    }
}

-(void)beginRefresh{
    [refreshControl beginRefreshing];
}

-(void)endRefresh{
    [refreshControl endRefreshing];
}


// runs in background thread
-(void) parseAllEventsWithOperation {
    for (FeedItem* feedItem in eventItems){
        if (![events objectForKey:feedItem.link]) {
            [self parseEventInformationsWithLink:feedItem.link]; 
        }
    }
    [self saveEventInfromationsToFile];
    NSLog(@"Parsing done");
}


-(void) parseEventInformationsWithLink:(NSString*) urlString{
    NSError *error = nil;
    
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:NULL];
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        //NSLog(@"Error: %@", error);
        return;
    }
    
    NSString* evPubDate = [NSString stringWithFormat:@""];
    NSString* evTitle = [NSString stringWithFormat:@""];
    NSString* evSubtitle = [NSString stringWithFormat:@""];
    NSString* evDescription = [NSString stringWithFormat:@""];
    
    HTMLNode *bodyNode = [parser body];
    NSArray *spanNodes = [bodyNode findChildTags:@"div"];
    
    for (HTMLNode *spanNode in spanNodes) {
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"news-single-item"]) {
            
            HTMLNode* time = [spanNode findChildWithAttribute:@"class" matchingName:@"news-single-timedata" allowPartial:YES] ;
            
            if (time) {
                evPubDate = [evPubDate stringByAppendingString:[time contents]];
            }
            // NSLog(@"%@",[time contents]);
            
            HTMLNode* title = [spanNode findChildTag:@"h1"];
            if (title) {
                evTitle = [evTitle stringByAppendingString:[title contents]];
            }
            //NSLog(@"%@",[arTitle contents]);
            
            HTMLNode* subtitle = [spanNode findChildTag:@"h2"];
            if (subtitle) {
                evSubtitle = [evSubtitle stringByAppendingString:[subtitle contents]];
            }
            // NSLog(@"%@",[subtitle contents]);
            
            NSArray *pNodes = [spanNode findChildTags:@"p"];
            if (pNodes) {
                for (HTMLNode *pNode in pNodes) {
                    if ([evDescription isEqualToString:@""] ) {
                        evDescription = [pNode rawContents];
                    }else {
                        evDescription = [NSString stringWithFormat:@"%@ %@", evDescription,[pNode rawContents]];
                    }
                }
            }
        }
        
    }
    
    evDescription = [evDescription cleanHtmlCodeInString];

    
    Event *event = [[Event alloc] initWithTitle:evTitle subTitle:evSubtitle pubDate:evPubDate description:evDescription];
    
    [events setObject:event forKey: urlString];
    
    
}

-(void)setEvent:(Event *)event forKey:(NSString *)key{
    [events setObject:event forKey: key];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  eventItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myCell";
    EventItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.title.text = [[eventItems objectAtIndex:indexPath.row] title];
    [cell setDate: [[eventItems objectAtIndex:indexPath.row] publicationDate]];

    [cell setDateImage];
    
	return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedItem = [eventItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showEvent" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showEvent"]) {
        Event* event = [events objectForKey:selectedItem.link];
        EventViewController* eventViewController = segue.destinationViewController;
        [eventViewController setEvent:event] ;
        [eventViewController setLink:selectedItem.link];
        eventViewController.delegate = self;
    }
}








-(void) parseNewInformations{
    rssFeed = [[RSSFeed alloc] initWithPath:@"http://www.uni-saarland.de/aktuelles/veranstaltungen.html?type=100&tx_ttnews[cat]=30" andDelegate:self];
    [rssFeed parse];
 //   [self parseAllEventsWithOperation];

}

-(void)loadSavedData{
    [self loadEventsFromFile];
    if (eventItems.count > 0) {
        [self.tableView reloadData];
    }
    
    NSInvocationOperation *loadEventInfoOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadEventInformationsFromFile) object:nil];
    [loadEventInfoOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [priorityQueueEvents addOperation:loadEventInfoOperation];}


-(void)refreshData{
    @try {
        
        if (eventItems.count<=0) {
            [self loadSavedData];
        }
        
        if ([Reachability hasInternetConnection]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            NSInvocationOperation *parseNewInformationsOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseNewInformations) object:nil];
            [parseNewInformationsOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
            [priorityQueueEvents addOperation:parseNewInformationsOperation];
        } else {
            UIAlertView *internetErrorAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"No internet conncetion", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"Events couldn´t be updated. Please check your internet connection and try again", nil)] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [internetErrorAlert show];

            [refreshControl endRefreshing];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        }
        
    }
    @catch (NSException *exception) {
    }
}



// should run in background thread
-(void) loadEventInformationsFromFile {
    
    NSString *filePath = [[self documentsDirectory] stringByAppendingPathComponent:@"mySavedEventArticlesDic"];
    
    NSDictionary* dic = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (dic.count>0) {
        events =  [[NSMutableDictionary alloc] initWithDictionary:dic];
    } else {
        events =  [[NSMutableDictionary alloc] init];
    }
}

-(void) saveEventInfromationsToFile {
    
    NSString *filePath = [[self documentsDirectory] stringByAppendingPathComponent:@"mySavedEventArticlesDic"];
    BOOL succeed = [[NSKeyedArchiver archivedDataWithRootObject:events] writeToFile:filePath atomically:YES];
    if (!succeed){ // do something  }
        NSLog(@"Event articles not Saved");
    }
}


-(void) loadEventsFromFile {
    
    NSString *filePath = [[self documentsDirectory] stringByAppendingPathComponent:@"mySavedEventsArray"];
    
    NSArray* arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (arr.count>0) {
        eventItems = [[NSMutableArray alloc] initWithArray:arr];
    }else{
        eventItems = [[NSMutableArray alloc] init];
    }
}

// should run in background thread
-(void) saveEventsToFile {

    NSString *filePath = [[self documentsDirectory] stringByAppendingPathComponent:@"mySavedEventsArray"];
    BOOL succeed = [[NSKeyedArchiver archivedDataWithRootObject:eventItems] writeToFile:filePath atomically:YES];
    if (!succeed){ // do something  }
        NSLog(@"Eventitems not Saved");
    }
}


-(NSString*)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    return documentsDirectory;
}



-(void)viewDidDisappear:(BOOL)animated{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    self.priorityQueueEvents = nil;
    self.events = nil;
    self.eventItems = nil;
    rssFeed = nil;
    self.selectedItem = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
