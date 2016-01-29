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

@interface MensaListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property NSUInteger pageIndex;
@property MensaItem *mensaitem;
@property IBOutlet UITableView *tableview;
@property (nonatomic, retain) IBOutlet UILabel *Tag;
@property (nonatomic) BOOL parsingSuccessful;
@property (nonatomic) NSMutableDictionary *days_dict;
@property (nonatomic) UIPageControl *pageControl;
-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;

-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;

//- (void) loadMensa;

@end