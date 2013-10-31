//
//  EventTableViewController.h
//  SaarlandUniversityAppB
//
//  Created by Matthias Sambale on 26.06.12.
//  Revised by Tom Michels  05-2013
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RssFeed.h"
#import "Event.h"
#import "Reachability.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "EventViewController.h"
#import "ODRefreshControl.h"
#import "NSString+HTMLCleaner.h"


@interface EventTableViewController : UITableViewController <RSSFeedDelegate>{
    RSSFeed *rssFeed;
    FeedItem *selectedItem;
    
    NSMutableArray* eventItems;
    NSMutableDictionary* events;
    NSOperationQueue *priorityQueueEvents;
    ODRefreshControl *refreshControl;

}

@property FeedItem* selectedItem;
@property NSMutableDictionary* events;
@property (nonatomic) NSMutableArray* eventItems;
@property NSOperationQueue *priorityQueueEvents;



-(void) parseEventInformationsWithLink:(NSString*) urlString;
- (void) refreshData;



@end
