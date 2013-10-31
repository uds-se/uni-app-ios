//
//  SaarlandUniversityAppBTests.m
//  SaarlandUniversityAppBTests
//
//  Created by Tobias Tykvart on 25.6.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "SaarlandUniversityAppBTests.h"
#import "Annotations.h"
#import "PointOfInterestsDic.h"
#import <MapKit/MapKit.h>
#import "RSSFeed.h"
#import "Database.h"

@implementation SaarlandUniversityAppBTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSetAnnotationProperly{
    Annotations *annot = [[Annotations alloc] init];
    annot.title = @"myTitle";
    annot.subtitle = @"aSubtitle";
    annot.website = @"myWebsite";
    annot.canShowLeftCalloutButton = YES;
    annot.canShowRightCalloutButton = NO;
    
    STAssertEquals(annot.title, @"myTitle", @"setTitle of Annoations doens´t work");
    STAssertEquals(annot.subtitle, @"aSubtitle", @"setSubtitle of Annoations doens´t work");
    STAssertEquals(annot.website, @"myWebsite", @"setWebsite of Annoations doens´t work");
    STAssertEquals(annot.canShowLeftCalloutButton, YES,@"setCansShowLeftCalloutButton of Annoations doens´t work");
    STAssertEquals(annot.canShowRightCalloutButton, NO, @"myTitle", @"setCansShowRightCalloutButton of Annoations doens´t work");
}

-(void) testDatabaseQueries{
    Database* db = [Database new];
    
    STAssertEquals([db openDb], true, @"opening DB doesn´t work");
    
    
    NSArray* arr = [db getPointOfInterestsIncludingMappingForKey:@"E11"];
    STAssertEqualObjects(((PointOfInterest*)[arr objectAtIndex:0]).ID, 24 , @"getPointOfInterestsIncludingMappingForKey doesn´t work");
    
    
    
    
    [db closeDb];
}


- (void) testChangeFormatOfString{
    STAssertEqualObjects([[PointOfInterestsDic class] changeFormatOfString:@"É"], @"E",@"Change Format of string É to E doesn´t work");
}

- (void) testGetFeedItemsDateGrouped{
    RSSFeed* feed = [[RSSFeed alloc] init];
    feed.feedItems = [[NSMutableArray alloc] init];
    
    FeedItem *item1 = [[FeedItem alloc] init];
    
    [item1.publicationDate  appendString: [NSString stringWithFormat:@"12 jun. 2012"]];
    [feed.feedItems addObject:item1];
    
    
    FeedItem *item2 = [[FeedItem alloc] init];
    [item2.publicationDate  appendString: [NSString stringWithFormat:@"12 jun. 2012"]];
    [feed.feedItems addObject:item2];
    
    FeedItem *item3 = [[FeedItem alloc] init];
    [item3.publicationDate  appendString: [NSString stringWithFormat:@"14 jul. 2012"]];
    [feed.feedItems addObject:item3];
    
    FeedItem *item4 = [[FeedItem alloc] init];
    [item4.publicationDate  appendString: [NSString stringWithFormat:@"15 jul. 2012"]];
    [feed.feedItems addObject:item4];
    
    FeedItem *item5 = [[FeedItem alloc] init];
    [item5.publicationDate  appendString: [NSString stringWithFormat:@"15 jul. 2012"]];
    [feed.feedItems addObject:item5];
    
    FeedItem *item6 = [[FeedItem alloc] init];
    [item6.publicationDate  appendString: [NSString stringWithFormat:@"15 jul. 2012"]];
    [feed.feedItems addObject:item6];
    
    FeedItem *item7 = [[FeedItem alloc] init];
    [item7.publicationDate appendString: [NSString stringWithFormat:@"16 jul. 2012"]];
    [feed.feedItems addObject:item7];
    
    NSMutableArray* refArray = [[NSMutableArray alloc] init];
    
    NSMutableArray* arr1 = [[NSMutableArray alloc] init];
    [arr1 addObject:item1];
    [arr1 addObject:item2];
    
    NSMutableArray* arr2 = [[NSMutableArray alloc] init];
    [arr2 addObject:item3];
    
    NSMutableArray* arr3 = [[NSMutableArray alloc] init];
    [arr3 addObject:item4];
    [arr3 addObject:item5];
    [arr3 addObject:item6];
    
    NSMutableArray* arr4 = [[NSMutableArray alloc] init];
    [arr4 addObject:item7];
    
    
    [refArray addObject:arr1];
    [refArray addObject:arr2];
    [refArray addObject:arr3];
    [refArray addObject:arr4];
    
    
    STAssertEqualObjects(refArray, feed.getFeedItemsDateGrouped, @"FeedItemsDateGrouped doesn´t work. %@ should be equal to %@",refArray,feed.getFeedItemsDateGrouped);
}






@end
