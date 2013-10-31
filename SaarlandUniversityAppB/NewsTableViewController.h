//
//  NewsTableViewController.h
//  SaarlandUniversityTest
//
//  Created by Tom Michels on 29.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RssFeed.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "NewsArticle.h"
#import "NewsArticleViewController.h"
#import "Reachability.h"
#import "ODRefreshControl.h"
#import "NSString+HTMLCleaner.h"

@interface NewsTableViewController : UITableViewController <RSSFeedDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,NewsArticleToNewsTable>{
    RSSFeed *rssFeed;
    FeedItem *selectedItem;
    
    NSMutableArray* newsItems;
    NSMutableDictionary* newsArticles;
    NSOperationQueue *priorityQueue;
    ODRefreshControl *refreshControl;

}

@property FeedItem *selectedItem;
//@property (nonatomic, retain) NSMutableDictionary* newsArticles;
@property (nonatomic) NSMutableArray* newsItems;
@property NSOperationQueue *priorityQueue;
@property NSMutableDictionary* newsArticles;


- (void) parseNewsArticleWithLink:(NSString*) urlString;
- (void) refreshData;
//gets called from NewsArticleViewController
- (void)setNewsArticle:(NewsArticle *)article forKey:(NSString *)key;
@end
