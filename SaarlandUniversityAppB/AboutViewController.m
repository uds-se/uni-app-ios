//
//  AboutViewController.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 20.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    
    
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [self bottomOfLowestContent:self.scrollView]+10);

    self.versionLabel.text = [@"Version: " stringByAppendingString: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSString *filename = @"HomeScreenBackgroundiPhone.jpg";
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if (screenRect.size.height == 568.0f)
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"-568@2x.jpg"];
        
        self.imageView.image = [UIImage imageNamed:filename];
    }
    
	// Do any additional setup after loading the view.
}


- (CGFloat) bottomOfLowestContent:(UIView*) view
{
    CGFloat lowestPoint = 0.0;
    
    BOOL restoreHorizontal = NO;
    BOOL restoreVertical = NO;
    
    if ([view respondsToSelector:@selector(setShowsHorizontalScrollIndicator:)] && [view respondsToSelector:@selector(setShowsVerticalScrollIndicator:)])
    {
        if ([(UIScrollView*)view showsHorizontalScrollIndicator])
        {
            restoreHorizontal = YES;
            [(UIScrollView*)view setShowsHorizontalScrollIndicator:NO];
        }
        if ([(UIScrollView*)view showsVerticalScrollIndicator])
        {
            restoreVertical = YES;
            [(UIScrollView*)view setShowsVerticalScrollIndicator:NO];
        }
    }
    for (UIView *subView in view.subviews)
    {
        if (!subView.hidden)
        {
            CGFloat maxY = CGRectGetMaxY(subView.frame);
            if (maxY > lowestPoint)
            {
                lowestPoint = maxY;
            }
        }
    }
    if ([view respondsToSelector:@selector(setShowsHorizontalScrollIndicator:)] && [view respondsToSelector:@selector(setShowsVerticalScrollIndicator:)])
    {
        if (restoreHorizontal)
        {
            [(UIScrollView*)view setShowsHorizontalScrollIndicator:YES];
        }
        if (restoreVertical)
        {
            [(UIScrollView*)view setShowsVerticalScrollIndicator:YES];
        }
    }
    
    return lowestPoint;
}



//done pressed. pops back to Homeviewcontroller
-(IBAction)donePressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

//opens Email dialoge to send feeback to "iosapp@uni-saarland.de"
- (IBAction)feedbackPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail] ) {
        MFMailComposeViewController* mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        // set some recipients ... but you do not need to do this :)
        [mc setToRecipients:[NSArray arrayWithObjects:@"iosApp@uni-saarland.de", nil]];
        
        // displaying our modal view controller on the screen with standard transition
        [self presentModalViewController:mc animated:YES];
    }
}

//mail delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    if(error) NSLog(@"ERROR - mailComposeController: %@", [error localizedDescription]);
    [self dismissModalViewControllerAnimated:YES];
    return;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
