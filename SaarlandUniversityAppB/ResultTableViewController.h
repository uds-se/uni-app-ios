//
//  ResultTableViewController.h
//  SaarlandUniversityAppB
//
//  Created by Jianan Ma on 12-7-12.
//  Revised by Tom Michels  05-2013
//  Copyright (c) 2012年 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "DetailTableViewController.h"
#import "Reachability.h"
#import "NSString+HTMLCleaner.h"

@interface ResultTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSIndexPath* selectedIndexPath;
    //NSString* fullURL;
    NSOperationQueue* backgroudnThread;
    NSMutableArray *names;
    NSMutableArray *links;
    NSMutableArray *functions;

}
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property NSIndexPath* selectedIndexPath;
@property (nonatomic) NSString* fullURL;
@property NSOperationQueue* backgroudnThread;



@end
