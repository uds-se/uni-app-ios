//
//  ResultStaffSearchViewController.h
//  Uni Saar
//
//  Created by Karsten on 26.01.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "DetailStaff.h"
#import "Reachability.h"

@interface ResultStaffSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSIndexPath* selectedIndexPath;
    NSMutableArray *names;
    NSMutableArray *links;
    
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;


@property NSIndexPath* selectedIndexPath;
@property (nonatomic) NSString* fullURL;
@property (nonatomic) NSString* searchParam;
@property NSOperationQueue* backgroudnThread;
@property (weak, nonatomic) IBOutlet UIView *noresult;
@property (weak, nonatomic) IBOutlet UILabel *nointernet;
@property (weak, nonatomic) IBOutlet UILabel *ergebnislabel;


@end
