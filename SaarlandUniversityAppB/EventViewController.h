//
//  EventViewController.h
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 14.07.12.
//  Revised by Tom Michels  05-2013
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "Reachability.h"
#import "AppSettings.h"
#import "UILabel+UILabel_AutoHeight.h"
#import "NSString+HTMLCleaner.h"

@protocol EventToEventTable <NSObject>
@required
-(void)setEvent:(Event *)event forKey:(NSString *)key;
@end

@interface EventViewController : UIViewController<UIAlertViewDelegate>{
    
    Event* event;
    
    __weak IBOutlet UILabel* evTitleLabel;
    __weak IBOutlet UILabel* evSubTitleLabel;
    __weak IBOutlet UILabel* evPubDateLabel;
    __weak IBOutlet UITextView*evDescriptionTextView;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIActivityIndicatorView* activityIndicatorView;

    __weak id <EventToEventTable> delegate;

    
    NSString* link;
    NSOperationQueue *priorityQueue;
    
    NSDictionary* settingsDic;
    int fontSizeToAdd;
    AppSettings* appSettings;
    int startSizeTitle;
    int startSizeSubtitle;
    int startSizeArticle;
    int startSizePubDate;
}


@property (nonatomic, copy) Event* event;
@property NSString* link;
@property NSOperationQueue *priorityQueue;
@property __weak id delegate;


-(void)increaseTextSize;
-(void)decreaseTextSize;

- (void) setEvent:(Event*) event;


@end
