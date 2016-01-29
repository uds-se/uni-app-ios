//
//  StaffSearchViewController.h
//  Uni Saar
//
//  Created by Karsten on 26.01.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultStaffSearchViewController.h"
@interface StaffSearchViewController : UIViewController <UITextFieldDelegate> {
    
    NSString *queryUrl;
}



@property (weak, nonatomic) IBOutlet UITextField *vorname;
@property (weak, nonatomic) IBOutlet UITextField *nachname;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


- (IBAction)buttonPressed:(id)sender;


@end

