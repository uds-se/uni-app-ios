//
//  StaffSearchViewController.h
//  Uni Saar
//
//  Created by Karsten on 26.01.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultStaffSearchViewController.h"
#import "Reachability.h"



@interface StaffSearchViewController : UIViewController <UITextFieldDelegate> {
    
    NSString *queryUrl;
}



@property (weak, nonatomic) IBOutlet UITextField *vorname;
@property (weak, nonatomic) IBOutlet UITextField *nachname;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *vnamelabel;
@property (weak, nonatomic) IBOutlet UILabel *nointernet;
@property (weak, nonatomic) IBOutlet UILabel *stafflabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *nnamelabel;


- (IBAction)buttonPressed:(id)sender;


@end

