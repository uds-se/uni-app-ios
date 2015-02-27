//
//  MensaViewController.h
//  SaarlandUniversity
//
//  Created by Tobias Tykvart on 21.6.12.
//  Revised by Tom Michels  05-2013
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CafeParser.h"
#import "MensaFeedParser.h"
#import "PanelsViewController.h"


@class MensaViewController;

@interface MensaViewController : PanelsViewController </*UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,*/CafeParserDelegate,MensaFeedParserDelegate>
{
    
    //page indiactor to show which day it is
    IBOutlet UIPageControl *pageControl;
    //navigation bar
    IBOutlet UINavigationItem *navigation;
    
    __weak IBOutlet UIImageView *backgroundImageView;

    __weak IBOutlet UIImageView *topMensaFoldImageView;
    
    __weak IBOutlet UIImageView *bottomMensaFoldImageView;
    //central data structure recieved from the parser with all menu items
    NSMutableDictionary *days_dict;

    //menu items for the cells
    NSMutableArray *contentForTables;
    //categories for the header of the cells
    NSMutableArray *contentForHeaders;
    //prices for the footer of the cells
    NSMutableArray *contentForFooters;
    //count of menu items for each day
    NSMutableArray *count;
    //colors of the menu items for each day
    NSMutableArray *colors;
    //dates of the current week
    NSMutableArray *dates;
    
    //is an animation to change the page running right now?
    BOOL pageControlIsChangingPage;
    
    BOOL parsingSuccessful;
    
    NSOperationQueue *priorityQueue;
    
}

//@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigation;
@property (nonatomic) IBOutlet UILabel* titleLabel;
@property (nonatomic) NSString* selectedCampus;


@property (nonatomic) NSMutableArray *colors;
@property (nonatomic) NSMutableArray *dates;
@property (nonatomic) NSMutableArray *contentForTables;
@property (nonatomic) NSMutableArray *contentForHeaders;
@property (nonatomic) NSMutableArray *contentForFooters;
@property (nonatomic) NSMutableArray *itemCount;
@property (nonatomic) NSMutableDictionary *days_dict;

@property (nonatomic) BOOL pageControlIsChangingPage;
@property (nonatomic) BOOL parsingSuccessful;

@property NSOperationQueue *priorityQueue;


- (IBAction)openingHoursClick:(id)sender;
-(void)updateModel;
-(void)updateView;
-(NSArray *)getSortedByDate;
-(NSArray *)getSortedByPlace;
-(NSDictionary *)getMensaItems;


@end
