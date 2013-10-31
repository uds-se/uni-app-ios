//
//  WebViewController.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 29.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "Reachability.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView,urlAsString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        

        
        
        // Custom initialization
    }
    return self;
}







- (void)viewDidLoad
{
    [super viewDidLoad];
    webView.delegate = self;
    webView.scalesPageToFit=YES;
    
    refreshControl = [[ODRefreshControl alloc] initInScrollView:webView.scrollView];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor colorWithRed:7/255.0f green:49/255.0f blue:92/255.0f alpha:1.0f];
    refreshControl.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    refreshControl.activityIndicatorViewColor = [UIColor colorWithRed:17/255.0f green:56/255.0f blue:92/255.0f alpha:1.0f];
    CGPoint point = CGPointMake(0, -45);
    [webView.scrollView setContentOffset:point animated:YES];

    [refreshControl beginRefreshing];
    [self refreshData];
    
    //[webView.scrollView zoomToRect:CGRectMake(65, 120, webView.frame.size.width*0.65, webView.frame.size.width*0.65) animated:YES];

}


- (void)viewDidAppear:(BOOL)animated{
  //  [webView.scrollView setZoomScale:1];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)refreshClicked:(id)sender {
    [self refreshData];
}


//refreshes the Data
-(void)refreshData{
    NSString *message;
    UIAlertView *internetErrorAlert;
    if ([[Reachability class] hasInternetConnection]) {
        if ([urlAsString rangeOfString:@"saarfahrplan.de"].length > 0 ) {
            CFTimeZoneRef timeRef= CFTimeZoneCopySystem();
            CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), timeRef);
            NSString* date = [NSString stringWithFormat:@"%i.%i.%i", (int)currentDate.day, (int)currentDate.month, (int)currentDate.year];
            NSString* time = [NSString stringWithFormat:@"%i:%i", currentDate.hour, currentDate.minute];
            NSString* newString = [urlAsString.copy stringByReplacingOccurrencesOfString:@"NEWDATE" withString:date];
            newString = [newString stringByReplacingOccurrencesOfString:@"NEWTIME" withString:time];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newString]]];
            CFRelease(timeRef);
        } else {
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlAsString]]];
        }
    } else {
        message = [NSString stringWithFormat:NSLocalizedString(@"Website couldn't be loaded. Please check your internet connection and try again",nil)];
        internetErrorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No internet conncetion",nil) message:message
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self webViewDidFinishLoad:webView];
        [internetErrorAlert show];
        
    }

}

-(void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[refreshControl endRefreshing];
}


// delegate of the button, shown on the alertview (when no intenret connection)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelectorOnMainThread:@selector(popVC) withObject:nil waitUntilDone:NO];
}

//pops the Viewcontroller
-(void) popVC{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)forwardPressed:(id)sender {
   
    if (webView.canGoForward){
        [webView goForward];
    }
}

- (IBAction)backPressed:(id)sender {
    if (webView.canGoBack){
        [webView goBack];
    }
}


@end
