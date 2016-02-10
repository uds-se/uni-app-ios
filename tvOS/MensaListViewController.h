//
//  MensaListViewController.h
//  Uni Saar
//
//  Created by Henrik on 18.12.15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "MensaFeedParser.h"
#import "MensaItem.h"
#import "Reachability.h"
#import "MensaListTableViewCell.h"

@interface MensaListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MensaFeedParserDelegate>

//Holds the Index of the displayed page
@property NSUInteger pageIndex;

//Stores a sorted days dict
@property (nonatomic) NSMutableArray *sorted_days;

//Stores all meals of a particular day
@property MensaItem *mensaitem;

//Stores the settings (Campus)
@property NSUserDefaults *defaults;

//checks if parsing successful (inherited by MensaFeedparser)
@property (nonatomic) BOOL parsingSuccessful;

//stores all parsed meals
@property (nonatomic) NSMutableDictionary *days_dict;

//Custom pagecontrol in ViewController (the dots on the bottom of the page
@property (nonatomic) UIPageControl *pageControl;


//Custom Table view in ViewController
@property IBOutlet UITableView *tableview;

//Date Label in ViewController
@property (nonatomic, retain) IBOutlet UILabel *current_date;

@property (nonatomic, retain) IBOutlet UILabel *no_internet;
//Called when AppleTV detects a swipe in the respective direction
-(IBAction)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer;
-(IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer;
-(void)parseFeeds;

@end