//
//  ViewController.m
//  SearchStaffWebView
//
//  Created by wenbin li on 12-7-5.
//  Copyright (c) 2012年 uni des saarlandes. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize backgroundView = _backgroundView;
/*@synthesize FamilyName = _FamilyName;
@synthesize FirstName = _FirstName;*/
//@synthesize queryUrl;

//@synthesize QueryURL;

- (void)viewDidLoad
{
    [super viewDidLoad];

    //adjust backgroundimage if on iPhone5
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSString *filename = @"HomeScreenBackgroundiPhone.jpg";
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if (screenRect.size.height == 568.0f)
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"-568@2x.jpg"];
        
        backgroundView.image = [UIImage imageNamed:filename];
    }
    
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ResultTableViewController* resultVC = segue.destinationViewController;
    [resultVC setFullURL:queryUrl];
}

//search button has been tapped
- (IBAction)searchPressed:(id)sender {
    if (self.FirstName.text.length<=0 && self.FamilyName.text.length<=0) {
        NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Please fill at least one search field",nil)];
        UIAlertView *emptyAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Empty search field",nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emptyAlert show];
    }else{
        if ([Reachability hasInternetConnection]) {
            queryUrl = [[NSString alloc] init];
            NSString* familyName = self.FamilyName.text;
            NSString* firstName = self.FirstName.text;

            if (!self.FamilyName.text) {
                familyName = @"";
            }
            if (!self.FirstName.text) {
                firstName = @"";
            }
            
            
            NSString* allQueryUrl = [NSString stringWithFormat: @"https://www.lsf.uni-saarland.de/qisserver/rds?state=wsearchv&search=7&purge=y&moduleParameter=person/person&personal.vorname=%@&personal.nachname=%@&P_start=0&P_anzahl=40&_form=display",firstName,familyName];
            NSString* profQueryUrl = [NSString stringWithFormat: @"https://www.lsf.uni-saarland.de/qisserver/rds?state=wsearchv&search=7&purge=y&moduleParameter=person/person&choice.r_funktion.pfid=y&r_funktion.pfid=171&personal.vorname=%@&personal.nachname=%@&P_start=0&P_anzahl=50&_form=display",firstName,familyName];
            
            if (self.segmentedControl.selectedSegmentIndex == 1) {
                queryUrl = allQueryUrl;
            }else{
                queryUrl = profQueryUrl;
            }
            
            [self performSegueWithIdentifier:@"showResults" sender:self];
        } else {
            NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Please check your internet connection and try again",nil)];
            UIAlertView *reachabilityAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No internet conncetion",nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [reachabilityAlert show];
        }
    }

}





-(void) viewDidDisAppear:(BOOL)animated{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (void)viewDidUnload
{
    [self setFamilyName:nil];
    [self setFirstName:nil];
    [self setBackgroundView:nil];
    [self setSegmentedControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
