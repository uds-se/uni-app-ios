//
//  DetailTableViewController.h
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 16.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMLNode.h"
#import "HTMLParser.h"
#import <MessageUI/MessageUI.h>  
#import "MapsViewController.h"
#import "Reachability.h"
#import "Database.h"



@interface DetailTableViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>{
    NSURL* fullURL;
    
    NSMutableArray* parsedInformations;
    NSMutableArray* heaerforInformations;
    
    IBOutlet UILabel* name;
    
    NSString* selectedBuilding;
    NSOperationQueue* backgroundThread;

}


@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property NSURL* fullURL;
@property NSMutableArray* parsedInformations;
@property NSMutableArray* heaerforInformations;
@property NSOperationQueue* backgroundThread;
@property NSString* selectedBuilding;



@property IBOutlet UILabel* name;




@end
