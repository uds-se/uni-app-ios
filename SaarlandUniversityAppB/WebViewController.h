//
//  WebViewController.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 29.05.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODRefreshControl.h"

@interface WebViewController : UIViewController <UIAlertViewDelegate,UIWebViewDelegate>{
    IBOutlet UIWebView * webView;
    NSString *urlAsString;
    ODRefreshControl* refreshControl;
}

@property IBOutlet UIWebView * webView;
@property (nonatomic) NSString * urlAsString;


- (IBAction)refreshClicked:(id)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)forwardPressed:(id)sender;

@end
