//
//  MensaViewController.m
//  SaarlandUniversity
//
//  Created by Tobias Tykvart on 21.6.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "MensaViewController.h"
#import "MensaFeedParser.h"
#import "Reachability.h"
#import "CafeParser.h"
#import "MensaView.h"


@interface MensaViewController ()

@end

@implementation MensaViewController


//incompele -> current date

@synthesize navigation, dates,/*scrollView,*/ pageControl, colors,
            contentForTables, contentForHeaders, contentForFooters,
            days_dict,  parsingSuccessful, pageControlIsChangingPage,
            priorityQueue,selectedCampus;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f


- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		
        // arrays of arrays of strings
        // containing the data for each day which will be inserted in the table view cells
        contentForTables = [[NSMutableArray alloc] init];
        contentForHeaders = [[NSMutableArray alloc] init];
        contentForFooters = [[NSMutableArray alloc] init];
        // array of dates, representing the date of each day
        dates = [[NSMutableArray alloc] init];
        // array of int, representing number of cells/menu items for each day
        self.itemCount = [[NSMutableArray alloc] init];
        // array of arrays of color (array of three numbers RGB) for each menu item
        colors = [[NSMutableArray alloc] init];
        
        
        days_dict = [[NSMutableDictionary alloc] init];
        
        //initializes the view with empty table views
        //[self initializeView];
        
        priorityQueue = [NSOperationQueue new];
        
	}
	return self;
}

/*
 * this method is called right after the view is loaded
 */
- (void)viewDidLoad
{
    //[self.view setBackgroundColor:[UIColor clearColor]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSString *filename = @"HomeScreenBackgroundiPhone.jpg";
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if (screenRect.size.height == 568.0f)
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"-568@2x.jpg"];
        
        backgroundImageView.image = [UIImage imageNamed:filename];
    }
   
    //tries to load data from file system, reloads data for table views only if data was loaded
    if ([self loadData]) {
        [self updateModel];
    }
    
    //[self parseFeeds];
    [self tryToParseFeeds];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

}


- (void)didBecomeActive:(NSNotification *)notification;
{
    [self tryToParseFeeds];
}

-(void)updateView{
    [super updateScrollViewSize];
    
    [self updateDayTitle];
    self.pageControl.numberOfPages = [self.contentForTables count];
    self.pageControl.currentPage = self.currentPage;
    
    for(UIView *subview in self.scrollView.subviews) {
        if ([subview isKindOfClass:[PanelView class]]) {
           
            [((UITableView*)subview) reloadData];
        }
    }
}


- (NSInteger)numberOfPanels
{
	int numberOfPanels = [self.contentForTables count]/*-1*/;
	return numberOfPanels;
}

- (CGRect)scrollViewFrame
{
    CGSize sizeOfScreen = [[UIScreen mainScreen] bounds].size;
    float viewHeight = sizeOfScreen.height - self.navigationController.navigationBar.frame.size.height;
    float distanceFromTop = topMensaFoldImageView.frame.origin.y+topMensaFoldImageView.frame.size.height-0.2;
    float distanceFromBottom = bottomMensaFoldImageView.frame.size.height;
	return CGRectMake(0,distanceFromTop,[self.view bounds].size.width,viewHeight-distanceFromTop-distanceFromBottom-[[UIApplication sharedApplication] statusBarFrame].size.height);
}



/**
 *
 * - (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
 * set number of rows for different panel & section
 *
 */
- (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
{
	return 1 ;
}


- (NSInteger)panelView:(PanelView *)panelView numberOfSectionsInPage:(NSInteger)page
{
	return [[self.contentForTables objectAtIndex:page] count] ;
}

/*
 * this method is called by the table view to determine the height of each cell
 */
- (CGFloat ) panelView:(PanelView* )panelView heightForRowAtIndexPath:(PanelIndexPath *)indexPath
{
    //get the text for current cell
    if (contentForTables.count == 0) {
        return 1;
    }
    NSString *text =  [[contentForTables objectAtIndex:indexPath.page] objectAtIndex:[indexPath section]];
    //constraints of the cell
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14]
                   constrainedToSize:constraint
                       lineBreakMode:NSLineBreakByWordWrapping/*UILineBreakModeWordWrap*/];
    
    CGFloat height = MAX(size.height, 10.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
}

/**
 *
 * - (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
 * use this method to change table view cells for different panel, section, and row
 *
 */
- (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
{
    //NSLog(@"Page :%d, cell: %d",indexPath.page, indexPath.section);
    
    static NSString *identity = @"UITableViewCell";
    UITableViewCell *cell = (UITableViewCell*)[panelView.tableView dequeueReusableCellWithIdentifier:identity];
    //initialise cell if necessary
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identity];
    }
    //set color for little color indicators on left and right
    NSString *redString = [NSString alloc];
    NSString *greenString = [NSString alloc];
    NSString *blueString = [NSString alloc];
    @try {
        redString = [[[colors objectAtIndex:indexPath.page] objectAtIndex:indexPath.section] objectAtIndex:0];
        greenString = [[[colors objectAtIndex:indexPath.page] objectAtIndex:indexPath.section] objectAtIndex:1];
        blueString = [[[colors objectAtIndex:indexPath.page] objectAtIndex:indexPath.section] objectAtIndex:2];
    }
    @catch (NSException *exception) {
        redString = @"0";
        greenString = @"85";
        blueString = @"142";
    }
    //convert the parsed strings to float values and divide by 255 so they are valid UIColors
    CGFloat redFloat = [redString floatValue]/255.f;
    CGFloat blueFloat = [blueString floatValue]/255.f;
    CGFloat greenFloat = [greenString floatValue]/255.f;
    UIColor *backgroundColor = [[UIColor alloc] initWithRed:redFloat green:greenFloat blue:blueFloat alpha:1.0];
    [cell setBackgroundColor:backgroundColor];
    //maximum lines in the cell
    cell.textLabel.numberOfLines = 10;
    //set color of the text box so there is a white box over the background color of the cell
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //set content of the cell
    if (contentForTables.count == 0) {
        return cell;
    }
    NSString *text = [[contentForTables objectAtIndex:indexPath.page]  objectAtIndex:[indexPath section]];
    //format the text to show umlaut
    NSString *utf8Text = [NSString stringWithUTF8String:[text UTF8String]];
    //show quotes correctly
    [cell.textLabel setText:[utf8Text stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];// [UIFont boldSystemFontOfSize:14];
    //switch off user interaction so cell doesn't get highlighted if touched
    cell.userInteractionEnabled = NO;
    return cell;
    
}



/*
 * this method is called by the table view to determine the height of each header
 */
- (CGFloat) panelView:(PanelView *)panelView heightForHeaderInSection:(NSInteger)section
{
	return 40.0;
}





/*
 * this method is called by the table view to determine how to format the header of each cell
 * where the food category is shown
 */
- (UIView *)panelView:(PanelView *)panelView viewForHeaderInPage:(NSInteger)page section:(NSInteger)section
{
    // create the parent view that will hold category Label
	UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44.0)];
	// create the button object
	UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //color of the lable
	categoryLabel.backgroundColor = [UIColor clearColor];
	categoryLabel.opaque = NO;
	categoryLabel.font = [UIFont boldSystemFontOfSize:18];
    //position of the lable
	categoryLabel.frame = CGRectMake(0.0, 15.0, categoryView.frame.size.width, 30.0);
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    //set the lable text
    if (contentForHeaders.count == 0) {
        return categoryView;
    }
    NSMutableArray *headers = [contentForHeaders objectAtIndex:page];
	categoryLabel.text = [headers objectAtIndex:section];
    
	[categoryView addSubview:categoryLabel];
    categoryView.backgroundColor = [UIColor clearColor];
	return categoryView;
}



/*
 * this method is called by the table view to determine the height of each footer
 */
- (CGFloat) panelView:(PanelView *)panelView heightForFooterInSection:(NSInteger)section
{
    return 15.0;
}

/*
 * this method is called by the table view to determine how to format the footer of each cell
 * where the prices are shown
 */
- (UIView *)panelView:(id)panelView viewForFooterInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    // create the parent view that will hold category Label
	UIView *pricesView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width - 20.0, 20.0)];
	// create the button object
	UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //color of the lable
	categoryLabel.backgroundColor = [UIColor clearColor];  ///heeeeeeerrrrrrrrrrrrrreereree
	categoryLabel.opaque = NO;
	categoryLabel.font = [UIFont systemFontOfSize:11];
    //position of the lable
	categoryLabel.frame = CGRectMake(0, 0.0, pricesView.frame.size.width, 15.0);
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    //set the lable text
    @try {
        NSString *price1 = @"";
        NSString *price2 = @"";
        NSString *price3 = @"";
        price1 = [[[contentForFooters objectAtIndex:pageNumber] objectAtIndex:section] objectAtIndex:0];
        price2 = [[[contentForFooters objectAtIndex:pageNumber] objectAtIndex:section] objectAtIndex:1];
        price3 = [[[contentForFooters objectAtIndex:pageNumber] objectAtIndex:section] objectAtIndex:2];
        price1 = [price1 stringByAppendingString:@"€"];
        price2 = [price2 stringByAppendingString:@"€"];
        price3 = [price3 stringByAppendingString:@"€"];
        if (price1.length == 1) {
            price1 = @"n.v.";
        }
        if (price2.length == 1) {
            price2 = @"n.v.";
        }
        if (price3.length == 1) {
            price3 = @"n.v.";
        }
        
        categoryLabel.text = [NSString stringWithFormat:
                              @"Studenten: %@ Mitarbeiter: %@ Besucher: %@", price1, price2, price3];
    }
    @catch (NSException *exception) {
        
    }
	
    
	[pricesView addSubview:categoryLabel];
    pricesView.backgroundColor = [UIColor clearColor];
	return pricesView;
}


/**
 *
 * - (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
 * similar to - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(IndexPath *)indexPath
 *
 */
- (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
{
	
}

/**
 *
 * - (PanelView *)panelForPage:(NSInteger)page
 * use this method to change panel types
 * SamplePanelView should subclass PanelView
 *
 */
- (PanelView *)panelForPage:(NSInteger)page
{
	static NSString *identifier = @"SamplePanelView";
	MensaView *mensaView = (MensaView*)[self dequeueReusablePageWithIdentifier:identifier];
	if (mensaView == nil)
	{
		mensaView = [[MensaView alloc] initWithIdentifier:identifier];
	}
	return mensaView;
}





/*
 * this method will update the data for the table views
 * it transfers the dictionary into different arrays, which are
 * needed to set up the table views
 */
- (IBAction)openingHoursClick:(id)sender {
    
    if([self.selectedCampus isEqualToString:@"saar"]){
    
        [self performSegueWithIdentifier:@"saarMensa" sender:self];
    }
    else{
        
        [self performSegueWithIdentifier:@"homburgMensa" sender:self];
    }
    
    
}

- (void)updateModel
{
    
    NSMutableArray *contentsRes = [[NSMutableArray alloc] init];
    NSMutableArray *headersRes = [[NSMutableArray alloc] init];
    NSMutableArray *footersRes = [[NSMutableArray alloc] init];
    NSMutableArray *colorsDayRes = [[NSMutableArray alloc] init];
    
    NSMutableArray* keysArr = days_dict.allKeys.mutableCopy;
    [keysArr sortUsingSelector:@selector(compare:)];
    
    for (int i = 0; i<keysArr.count;i++) {
        NSArray* currentDay = [days_dict objectForKey:[keysArr objectAtIndex:i]];
        [count addObject:[NSNumber numberWithInt:currentDay.count]];
        
        NSMutableArray *contents = [[NSMutableArray alloc] init];
        NSMutableArray *headers = [[NSMutableArray alloc] init];
        NSMutableArray *footers = [[NSMutableArray alloc] init];
        NSMutableArray *colorsDay = [[NSMutableArray alloc] init];
        
        BOOL dateSet = NO;
        // for every mensa item of current day the data has to be extracted from the MensaItem
        for (int j = 0; j < currentDay.count; j++) {
            @try {
                // get current mensa item
                if ([currentDay objectAtIndex:j] != nil) {
                    MensaItem *mensaItem = [currentDay objectAtIndex:j];
                    // set date
                    if (dateSet == NO) {
                        if (mensaItem.tag != nil) {
                            NSDate *itemDate = mensaItem.tag;
                            //get the day.month.year from NSDate
                        
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"EEEE, dd MMMM"];
                            NSLocale *deLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
                            [formatter setLocale:deLocale];
                            //[formatter setLocale:[NSLocale currentLocale]];
                            NSString *stringFromDate = [formatter stringFromDate:itemDate];
                            [dates addObject:stringFromDate];
                            // date needs to be set only once for each day but is stored in every mensa item
                            dateSet = YES;
                        }
                    }
                    // set category, shown in the header of a cell
                    NSString *itemCategory = @"Menu";
                    if (mensaItem.category != nil) {
                        itemCategory = mensaItem.category;
                    }
                    [headers addObject:itemCategory];
                    // set title and description, shown together in the content of a cell
                   // if (mensaItem.title != nil & mensaItem.desc != nil) {
                        NSString *itemTitle = mensaItem.title;
                        NSString *itemDescription = mensaItem.desc;
                        [contents addObject:[NSString stringWithFormat:
                                             @"%@ %@", itemTitle, itemDescription]];
                    //}
                    // set prices, shown in the footer of a cell
                    NSString *preis1 = @"";
                    if (mensaItem.preis1 != nil) {
                        preis1 = mensaItem.preis1;
                    }
                    NSString *preis2 = @"";
                    if (mensaItem.preis2 != nil) {
                        preis2 = mensaItem.preis2;
                    }
                    NSString *preis3 = @"";
                    if (mensaItem.preis3 != nil) {
                        preis3 = mensaItem.preis3;
                    }
                    NSArray *prices = [[NSArray alloc] initWithObjects:preis1, preis2, preis3, nil];
                    [footers addObject:prices];
                    //set colors, parsed as three numbers separated by comma
                    NSString *colorString = @"";
                    if (mensaItem.color != nil) {
                        colorString = mensaItem.color;
                    }
                    NSArray *colorArray = [colorString componentsSeparatedByString:@","];
                    [colorsDay addObject:colorArray];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"failed to transfer data from days_dict to arrays");
            }
        }
        // after all mensa items of current day are processed
        // the temporary arrays can be added to the stored arrays
        // continuing with next day
        [contentsRes addObject:contents];
        [headersRes addObject:headers];
        [footersRes addObject:footers];
        [colorsDayRes addObject:colorsDay];
    }

    contentForTables = contentsRes;
    contentForHeaders = headersRes;
    contentForFooters = footersRes;
    colors = colorsDayRes;
    
    contentsRes = nil;
    headersRes = nil;
    footersRes = nil;
    colorsDayRes = nil;
    
    [self updateView];
    
}


/*
 *Check reachability before trying to parse
 */
-(void)tryToParseFeeds{
    NSString *message = [self checkReachability];
    if (message == nil){
        // parse feeds in new thread to show latest menus
        @try {
            NSInvocationOperation *parseMenuInformationsOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseFeeds) object:nil];
            [parseMenuInformationsOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
            [priorityQueue addOperation:parseMenuInformationsOperation];
        }
        @catch (NSException *exception) {
            NSLog(@"parsing failed");
        }
    } else {
        UIAlertView *parseErrorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error",nil)
                                                                  message:message
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        [parseErrorAlert show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }

}




/*
 * this method parses all feeds
 * will be called in a background thread
 * This method should not be called by your own.  Use tryToParseFeeds
 */
- (void) parseFeeds
{
    // source urls of menus
    
    if([selectedCampus isEqualToString:@"saar"]){
        NSURL *mensaFeed = [[NSURL alloc]
                         initWithString:@"http://studentenwerk.netzindianer.net/_menu/actual/speiseplan-saarbruecken.xml"];
//        NSURL *mensaFeed = [[NSURL alloc]
//                            initWithString:@"http://studentenwerk.netzindianer.net/_menu/actual/speiseplan-homburg.xml"];
        NSURL *acFeed = [[NSURL alloc]
                     initWithString:@"http://www.uni-saarland.de/campus/service-und-kultur/gastronomieaufdemcampus/auslaender-cafe.html"];
   
    
        NSURL *jcFeed = [[NSURL alloc]
                     initWithString:@"http://www.uni-saarland.de/campus/service-und-kultur/gastronomieaufdemcampus/juristen-cafe.html"];
    
    
        // setup of parsers for above-mentioned urls
        MensaFeedParser *mensaParser = [MensaFeedParser alloc];
        CafeParser *acParser = [CafeParser alloc];
        CafeParser *jcParser = [CafeParser alloc];
    
        @try {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [mensaParser initParser:mensaFeed withDict:days_dict andDelegate:self];
        }
        @catch (NSException *exception) {
            parsingSuccessful = NO;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"Mensa parser failed");
        }
    
        @try {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [acParser initParser:acFeed withCategory:@"Ausländer-Café"
                                    withDict:days_dict andDelegate:self];
        }
        @catch (NSException *exception) {
            parsingSuccessful = NO;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"Ausländer-Cafe parser failed");
        }
    
        
        @try {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [jcParser initParser:jcFeed withCategory:@"Juristencafé"
                                    withDict:days_dict andDelegate:self];
        }
        @catch (NSException *exception) {
            parsingSuccessful = NO;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"Juristencafe parser failed for Saarbrucken");
        }
    }
    else{
        NSLog(@" INSIDE ELSE");
        NSURL *mensaFeed = [[NSURL alloc]
                            initWithString:@"http://studentenwerk.netzindianer.net/_menu/actual/speiseplan-homburg.xml"];
        MensaFeedParser *mensaParser = [MensaFeedParser alloc];
        @try {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [mensaParser initParser:mensaFeed withDict:days_dict andDelegate:self];
        }
        @catch (NSException *exception) {
            parsingSuccessful = NO;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"Mensa parser failed for Homburg");
        }
    }
        
    if (parsingSuccessful) {
        
        [self performSelectorOnMainThread:@selector(updateModel) withObject:nil waitUntilDone:NO];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

/*
 * this method is called in the background thread by the parser after parsing ended
 * it will update the model, reload the data of the table views and thus show the new data
 */
-(void)parsingDidEnd:(NSMutableDictionary *)parsedDictionary
{
    // the new dictionary 
    days_dict = parsedDictionary;
    //[self performSelectorOnMainThread:@selector(updateModel) withObject:nil waitUntilDone:NO];
    
    parsingSuccessful = YES;
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


/*
 * this method is executed after a scrolling action ended
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    [super scrollViewDidEndDecelerating:_scrollView];
    pageControlIsChangingPage = NO;
    self.pageControl.currentPage = self.currentPage;
    [self updateDayTitle];
    for(UIView *subview in self.scrollView.subviews) {
        if ([subview isKindOfClass:[PanelView class]]) {
            [((UITableView*)subview) reloadData];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self updateDayTitle];
}




-(void)updateDayTitle{
   // NSMutableArray* keysArr = [dictionary allKeys].mutableCopy;
   // [keysArr sortUsingSelector:@selector(compare:)];
    if (dates.count>0) {
        NSString* stringDate =  [dates objectAtIndex:self.currentPage];
        
        self.titleLabel.text =  stringDate.copy;
    } else{
        self.titleLabel.text =  @"";
    }

}


/*
 * this method checks if internet connection is available
 */
- (NSString *)checkReachability
{
    NSString *message;
    if (![[Reachability class] hasInternetConnection]) {
        message = [NSString stringWithFormat:NSLocalizedString(@"Restaurant informations couldn't be updated. Please check your internet connection and try again",nil)];
    }
    return message;
}



/*
 * this method is called if mensa screen is closed
 */
- (void)viewDidDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self saveData];
}

/*
 * this method returns the file path where to save the days_dict
 */
-(NSString*) saveFilePath
{
    //save in documents folder as plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path;
    
    if([selectedCampus isEqualToString:@"saar"]){
        path = [NSString stringWithFormat:@"%@%@",
                  documentsDirectory,
                  @"/days_dict_sb.plist"];
    }
    else{
        path = [NSString stringWithFormat:@"%@%@",
                documentsDirectory,
                @"/days_dict_hb.plist"];
    }
    
    
    return path;
}

/*
 * this method is called if mensa screen is closed and saves the menu
 */
-(void) saveData
{
    //save only if parsing succeeded, otherwise a intact file may be overwritten by an empty one
    if (parsingSuccessful) {
        NSString *path = [self saveFilePath];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSMutableArray* keysArr = [days_dict allKeys].mutableCopy;
        [keysArr sortUsingSelector:@selector(compare:)];

        
        for (int i=0; i<keysArr.count; i++) {
            NSMutableArray *currentDay = [days_dict objectForKey:[keysArr objectAtIndex:i]];
            NSMutableDictionary *dayDict = [[NSMutableDictionary alloc] init];
            for (int j=0; j<currentDay.count; j++) {
                MensaItem *currentItem = [currentDay objectAtIndex:j];
                //convert all MensaItems to dictionaries
                NSDictionary *currentDictionary = [self convertMensaItemToDictionary:currentItem];
                [dayDict setObject:currentDictionary forKey:[NSString stringWithFormat:@"%d", j]];
            }
            [dict setObject:dayDict forKey:[keysArr objectAtIndex:i]];
        }
        [dict writeToFile:path atomically:YES];
    }
}


/*
 * removes saved menus that are from the past
 */
-(BOOL)removeOldDataFromPlist{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self saveFilePath]]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]
                                           initWithContentsOfFile:[self saveFilePath]];
        NSMutableArray* keysArr = [dictionary allKeys].mutableCopy;
        [keysArr sortUsingSelector:@selector(compare:)];
        
        double yesterday23h59 = [self getTimestampOfTodayAt0am]-1;
        
        for (int i=0; i<keysArr.count; i++) {
            if (yesterday23h59 > [[keysArr objectAtIndex:i] doubleValue]) {
                //[keysArr removeObjectAtIndex:i];
                [dictionary removeObjectForKey:[keysArr objectAtIndex:i]];
            }
        }
        
        NSString *path = [self saveFilePath];
        [dictionary writeToFile:path atomically:YES];

        
        return YES;
    
    }else{
        return NO;
    }
}

/*
 * this method is called if the saved menu has to be loaded
 * out of date data is not loaded, and remove from saved data
 */
-(BOOL) loadData
{
    //load only if file is available
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [self removeOldDataFromPlist];
    
    if ([fileManager fileExistsAtPath:[self saveFilePath]]) {
        //load the dictionary from the documents directory
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]
                                           initWithContentsOfFile:[self saveFilePath]];
        NSMutableArray* keysArr = [dictionary allKeys].mutableCopy;
        [keysArr sortUsingSelector:@selector(compare:)];
        

        
        for (int i=0; i<keysArr.count; i++) {
            NSMutableArray *dayArray  = [NSMutableArray new];
            NSMutableDictionary *currentDay = [dictionary objectForKey:[keysArr objectAtIndex:i]];
            for (int j=0; j<currentDay.count; j++) {
                NSMutableDictionary *currentDictionary = [currentDay objectForKey:[NSString stringWithFormat:@"%d", j]];
                //convert each found mensa item dictionary back a MensaItem
                MensaItem *currentItem = [self convertDictionaryToMensaItem:currentDictionary];
                [dayArray addObject:currentItem];
                
                //NSMutableArray *dayArray = [days_dict objectForKey:[keysArr objectAtIndex:i]];
                //[dayArray addObject:currentItem];
            }
            [days_dict setObject:dayArray forKey:[keysArr objectAtIndex:i]];
            
        }

        return YES;
    }
    return NO;
}

-(double )getTimestampOfTodayAt0am{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [components setHour:0];
    
    return [[calendar dateFromComponents:components] timeIntervalSince1970];
}

/*
-(void) loadMensaDataFromFile {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedArray = [currentDefaults objectForKey:@"mySavedMensaArray"];
    if (savedArray != nil)
    {
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (oldArray != nil) {
            newsItems = [[NSMutableArray alloc] initWithArray:oldArray];
        } else {
            newsItems = [[NSMutableArray alloc] init];
        }
    }
}

-(void) saveMensaDataToFile {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:newsItems] forKey:@"mySavedMensaArray"];
}

*/


/*
 * this method should return all menu items sorted by date
 * (not implemented)
 */
- (NSArray *)getSortedByDate
{
    return NULL;
}

/*
 * this method should return all menu items sorted by restaurant
 * (not implemented)
 */
- (NSArray *)getSortedByPlace
{
    return NULL;
}

/*
 * this method will return all menu items
 */
- (NSDictionary *)getMensaItems
{
    return days_dict;
}




/*
 * this method converts a MensaItem to a dictionary so it can be saved in a plist
 */
- (NSDictionary *) convertMensaItemToDictionary:(MensaItem *) mensaItem
{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"category", @"desc", @"title", @"tag", @"kennzeichnungen", @"beilagen", @"preis1", @"preis2", @"preis3", @"color", nil];
    NSString *category = @"";
    NSString *desc = @"";
    NSString *title = @"";
    NSDate *tag = [[NSDate alloc] init];
    NSString *kennzeichnungen = @"";
    NSString *beilagen = @"";
    NSString *preis1 = @"";
    NSString *preis2 = @"";
    NSString *preis3= @"";
    NSString *color = @"";
    if (mensaItem.category != nil) {
        category = mensaItem.category;
    }
    if (mensaItem.desc != nil) {
        desc = mensaItem.desc;
    }
    if (mensaItem.title != nil) {
        title = mensaItem.title;
    }
    if (mensaItem.tag != nil) {
        tag = mensaItem.tag;
    }
    if (mensaItem.kennzeichnungen != nil) {
        kennzeichnungen = mensaItem.kennzeichnungen;
    }
    if (mensaItem.beilagen != nil) {
        beilagen = mensaItem.beilagen;
    }
    if (mensaItem.preis1 != nil) {
        preis1 = mensaItem.preis1;
    }
    if (mensaItem.preis2 != nil) {
        preis2 = mensaItem.preis2;
    }
    if (mensaItem.preis3 != nil) {
        preis3 = mensaItem.preis3;
    }
    if (mensaItem.color != nil) {
        color = mensaItem.color;
    }
    NSArray *values = [[NSArray alloc] initWithObjects:category, desc, title, tag, kennzeichnungen, beilagen, preis1, preis2, preis3, color, nil];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    return dictionary;
}

/*
 * this method converts a saved dictionary back to a mensa item
 */
- (MensaItem *) convertDictionaryToMensaItem:(NSDictionary *) dictionary
{
    MensaItem *mensaItem = [[MensaItem alloc] init];
    mensaItem.category = [dictionary objectForKey:@"category"];
    mensaItem.desc = [dictionary objectForKey:@"desc"];
    mensaItem.tag = [dictionary objectForKey:@"tag"];
    mensaItem.title = [dictionary objectForKey:@"title"];
    mensaItem.kennzeichnungen = [dictionary objectForKey:@"kennzeichnungen"];
    mensaItem.beilagen = [dictionary objectForKey:@"beilagen"];
    mensaItem.preis1 = [dictionary objectForKey:@"preis1"];
    mensaItem.preis2 = [dictionary objectForKey:@"preis2"];
    mensaItem.preis3 = [dictionary objectForKey:@"preis3"];
    mensaItem.color = [dictionary objectForKey:@"color"];
    return mensaItem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




- (void)viewDidUnload
{
    backgroundImageView = nil;
    topMensaFoldImageView = nil;
    bottomMensaFoldImageView = nil;
    [super viewDidUnload];
    days_dict = nil;
    pageControl = nil;
    navigation = nil;
    contentForTables = nil;
    contentForHeaders = nil;
    contentForFooters = nil;
    count = nil;
    colors = nil;
    dates = nil;
    priorityQueue = nil;
    
    
    // Release any retained subviews of the main view.
}

@end
