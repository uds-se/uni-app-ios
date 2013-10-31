//
//  RSSFeed.h
//  SaarlandUniversityTest
//
//  Created by Tom Michels on 29.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"



#pragma mark -
#pragma mark RSS Feed Delegate Protocol

@protocol RSSFeedDelegate <NSObject>
@required
// This delegate is to allow callbacks to the class that called the RSS Feed.
- (void)RSSFeedParserDidEndDocument;
@end


@interface RSSFeed : NSObject <NSXMLParserDelegate> {
	NSMutableArray * feedItems;				// Our array of feed items
    NSArray * feedItemsDateGrouped;
	NSXMLParser	* feedParser;			// Feed parser
	FeedItem * refFeedItem;			// Reference to our current feed item
	NSString * currentFeedElement;	// The current feed item element we are parsing
	NSString * path;                //path to parse
	__weak id <RSSFeedDelegate> delegate;
}

@property	(nonatomic, retain)		NSMutableArray	*feedItems;
@property	(nonatomic, retain)		NSArray	*feedItemsDateGrouped;

@property	(nonatomic,weak)	id delegate;
@property   (nonatomic) NSString * path;


//initialisation
- (id)initWithPath:(NSString *)feedPath andDelegate:(id<RSSFeedDelegate>)theDelegate;

- (NSMutableArray *) getFeedItemsDateGrouped;

- (void)parse;

@end
