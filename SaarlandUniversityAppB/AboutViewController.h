//
//  AboutViewController.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 20.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutViewController : UIViewController<MFMailComposeViewControllerDelegate>{
}

@property (nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

-(IBAction)donePressed:(id)sender;
- (IBAction)feedbackPressed:(id)sender;

@end
