//
//  ViewController.h
//  SearchStaffWebView
//
//  Created by wenbin li on 12-7-5.
//  Revised by Tom Michels  05-2013
//  Copyright (c) 2012年 uni des saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultTableViewController.h"
#import "Reachability.h"
//#import "WebViewController.h"

@interface SearchViewController : UIViewController <UITextFieldDelegate>{
    IBOutlet UIImageView *backgroundView;
    NSString* queryUrl;

}
@property (nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

@property (nonatomic) IBOutlet UITextField *FamilyName;
@property (nonatomic) IBOutlet UITextField *FirstName;
//@property     NSString* queryUrl;


- (IBAction)searchPressed:(id)sender;

@end
